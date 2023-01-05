let gengJSON = {
    "upstream node_upstream": {
        "ip_hash": "",
        "server": [
            "192.168.1.3:9000 max_fails=5 fail_timeout=30",
            "192.168.1.2:9000 max_fails=5 fail_timeout=30",
            "192.168.1.4:9000 max_fails=5 fail_timeout=30"
        ]
    },
    "server": {
        "listen": [
            "443 ssl",
            "80"
        ],
        "server_name": "app.example.com",
        "ssl": "on",
        "ssl_certificate": "/etc/nginx/certificate.crt",
        "ssl_certificate_key": "/etc/nginx/privKey.key",
        "ssl_session_timeout": "5m",
        "ssl_protocols": "SSLv2 SSLv3 TLSv1",
        "ssl_ciphers": "ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP",
        "ssl_prefer_server_ciphers": "on",
        "if ($ssl_protocol = \"\")": {
            "rewrite": "^ https://$host$request_uri? permanent"
        },
        "location /": {
            "proxy_pass": "http://node_upstream"
        },
        "location /sockjs": {
            "proxy_set_header": [
                "Upgrade $http_upgrade",
                "Connection \"upgrade\"",
                "X-Forwarded-For $proxy_add_x_forwarded_for",
                "Host $host"
            ],
            "proxy_http_version": "1.1",
            "proxy_pass": "http://node_upstream"
        }
    }
}

let gengConf = `upstream node_upstream {
    ip_hash;
    server     192.168.1.2:9000 max_fails=5 fail_timeout=30;
    server     192.168.1.3:9000 max_fails=5 fail_timeout=30;
    server     192.168.1.4:9000 max_fails=5 fail_timeout=30;
}

server {
    listen                       80;
    listen                       443 ssl;

    server_name                  app.example.com;

    ssl                          on;
    ssl_certificate              /etc/nginx/certificate.crt;
    ssl_certificate_key          /etc/nginx/privKey.key;
    ssl_session_timeout          5m;
    ssl_protocols                SSLv2 SSLv3 TLSv1;
    ssl_ciphers                  ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;
    ssl_prefer_server_ciphers    on;

    if ($ssl_protocol = "") {
        rewrite ^ https://$host$request_uri? permanent;
    }

    location / {
        proxy_pass    http://node_upstream;
    }

    location /sockjs {
        proxy_set_header      Connection "upgrade";
        proxy_set_header      Upgrade $http_upgrade;
        proxy_set_header      X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header      Host $host;
        proxy_http_version    1.1;
        proxy_pass            http://node_upstream;
    }

}`


function unsafeKey(key) {
    return key.replace(/(!)/g, '.')
}


function safeKey(key) {
    return key.replace(/(\.)/g, '!')
}

class Parser {
    constructor() {
        // Last used file name
        this.fileName = null
        this.serverRoot = null
    }

  
    setFileName(fileName) {
        this.fileName = fileName
        // Get the server root only if not set
        if (this.serverRoot === null) {
            this.serverRoot = dirname(fileName)
        }
    }


    resolve(obj, path) {
        return path.split('.').reduce((prev, curr) => {
            return (typeof prev === 'object' && prev) ? prev[unsafeKey(curr)] : undefined
        }, obj)
    }

    resolveSet(obj, path, val) {
        const components = path.split('.')
        while (components.length > 0) {
            if (typeof (obj) !== 'object') break

            if (components.length === 1) {
                obj[unsafeKey(components[0])] = val
                return true
            } else {
                obj = obj[unsafeKey(components.shift())]
            }
        }
        return false
    }

    parse(mixed, options) {
        // Contents can return Buffer - convert it to string
        if (Buffer.isBuffer(mixed)) {
            mixed = mixed.toString('utf8')
        }
        if (typeof mixed === 'object') return this.toConf(mixed)
        else if (typeof mixed === 'string') return this.toJSON(mixed, options)
        else throw new TypeError(`Expected an Object or String, but got "${typeof mixed}"`)
    }

    toJSON(conf, options = { parseIncludes: false }) {
        // split multi-line string to array of lines. Remove TAB characters
        const lines = conf.replace('\t', '').split('\n')
        const json = {} // holds constructed json
        let parent = '' // parent keys as we descend into object
        let chunkedLine = null // aggregator for multi-lines directives
        let innerLines = [] // array for blocks extracted from multi-blocks line
        let countOfParentsThatAreArrays = 0 // how many of the parent keys are arrays
        let isInLuaBlock = false
        let luaBlockValue = []

        lines.forEach(lineRaw => {
            lineRaw = lineRaw.trim() // prep for `startsWith` and `endsWith`

            // If line is blank line or is comment, do not process it
            if (!lineRaw || lineRaw.startsWith('#')) return

            // Line can contain comments, we need to remove them
            lineRaw = lineRaw.split('#')[0].trim()

            innerLines = lineRaw
                .replace(/(\s+{)/g, '\n$1\n')
                .replace(/(;\s*)}/g, '$1\n}\n')
                .replace(/;\s*?$/g, ';\n')
                .split(/\n/)

            innerLines.forEach(line => {
                line = line.trim()
                if (!line) return

                // If we're in a lua block, append the line to the luaBlockValue and continue
                if (isInLuaBlock && !line.endsWith('}')) {
                    luaBlockValue.push(line)
                    return
                }

                chunkedLine && (line = chunkedLine + ' ' + line)

  
                if (line.endsWith('{')) {
                    chunkedLine = null
                    const key = safeKey(line.slice(0, line.length - 1).trim())
                    if (key.endsWith('by_lua_block')) {
                        // flip isInLuaBlock to true to disable parsing of tokens within this block
                        isInLuaBlock = true
                    }

                    // If we are already a level deep (or more), add a dot before the key
                    if (parent) parent += '.' + key
                    // otherwise just track the key
                    else parent = key

                    // store in constructed `json` (support array resolving)
                    if (this.appendValue(json, parent, {})) {
                        // Array was used and we need to update the parent key with an index
                        parent += '.' + (this.resolve(json, parent).length - 1)
                        countOfParentsThatAreArrays += 1
                    }
                }
                /*
                  2. Standard inlcude line
                  Load external file config and merge it into current json structure
                */
                else if (line.startsWith('include') && options.parseIncludes) {
                    chunkedLine = null
                    // Resolve find path in the include (can use wildcard and relative paths)
                    const findFiles = resolve(
                        this.serverRoot || options.includesRoot || '',
                        line.replace('include ', '').replace(';', '').trim()
                    )
                    const files = glob.sync(findFiles)

                    files.forEach((file) => {
                        // Get separate parser that will parse included file
                        const parser = new Parser()
                        // Pass the current server root - includes in the file
                        // must be originating from the conf root
                        parser.serverRoot = this.serverRoot

                        // Include contains path to file, it can be relative/absolute - resolve the path
                        const config = parser.readConfigFile(file)

                        // Get all found key values and resolve in current tree structure
                        for (const key in config) {
                            const val = config[key]
                            this.appendValue(json, key, val, parent)
                        }
                    })

                    if (!files.length) {
                        throw new ReferenceError(`Unable to resolve include statement: "${line}".\nSearched in ${this.serverRoot || options.includesRoot || process.cwd()}`)
                    }
                }
                /*
                  3. Standard property line
                  Create a key/value pair in the constructed `json`, which
                  reflects the key/value in the conf file.
                */
                else if (line.endsWith(';')) {
                    chunkedLine = null
                    line = line.split(' ')

                    // Put the property name into `key`
                    let key = safeKey(line.shift())
                    // Put the property value into `val`
                    let val = line.join(' ').trim()

                    // If key ends with a semi-colon, remove that semi-colon
                    if (key.endsWith(';')) key = key.slice(0, key.length - 1)
                    // Remove trailing semi-colon from `val` (we established its
                    // presence already)
                    val = val.slice(0, val.length - 1)
                    this.appendValue(json, key, val, parent)
                }
                /*
                  4. Object closing line
                  Removes current deepest `key` from `parent`
                  e.g. "server.location /api" becomes "server"
                */
                else if (line.endsWith('}')) {
                    chunkedLine = null
                    // If we're in a lua block, make sure the final value gets stored before moving up a level
                    if (isInLuaBlock) {
                        this.appendValue(json, '_lua', luaBlockValue, parent)
                        luaBlockValue = []
                        isInLuaBlock = false
                    }

                    // Pop the parent to go lower
                    parent = parent.split('.')

                    // check if the current level is an array
                    if (countOfParentsThatAreArrays > 0 && !isNaN(parseInt(parent[parent.length - 1], 10))) {
                        parent.pop() // remove the numeric index from parent
                        countOfParentsThatAreArrays -= 1
                    }
                    parent.pop()
                    parent = parent.join('.')
                }
                /*
                  5. Line may not contain '{' ';' '}' symbols at the end
                  e.g. "location /api
                        { ... }"
                  Block begins from the new line here.
                */
                else {
                    chunkedLine = line
                }
            })
        })

        return json
    }

    /**
     * Resolve setting value with merging existing value and converting it
     * to array. When true is returned, an array was used
     * @return bool
     */
    resolveAppendSet(json, key, val) {
        let isInArray = false
        const existingVal = this.resolve(json, key)
        if (existingVal) {
            // If we already have a property in the constructed `json` by
            // the same name as `key`, convert the stored value from a
            // String, to an Array of Strings & push the new value in.
            // Also support merging arrays
            let mergedValues = []

            // Should we merge new array with existing values?
            if (Array.isArray(existingVal)) {
                mergedValues = existingVal
            } else if (typeof existingVal !== 'undefined') {
                mergedValues.push(existingVal)
            }

            // If given value is already array and current existing value is also array,
            // merge the arrays together
            if (Array.isArray(val)) {
                val.forEach(function (value) {
                    mergedValues.push(value)
                })
            } else {
                mergedValues.push(val)
            }

            val = mergedValues
            isInArray = true
        }

        this.resolveSet(json, key, val)

        return isInArray
    }


    appendValue(json, key, val, parent = undefined) {
        // Key within the parent
        if (parent) {
            return this.resolveAppendSet(json, parent + '.' + key, val)
        } else {
            // Top level key/val, just create property in constructed
            // `json` and store val
            return this.resolveAppendSet(json, key, val)
        }
    }


    toConf(json) {
        const recurse = (obj, depth) => {
            let retVal = ''
            let longestKeyLen = 1
            const indent = ('    ').repeat(depth)

            for (const key in obj) {
                longestKeyLen = Math.max(longestKeyLen, key.length)
            }

            for (const key in obj) {
                const val = obj[key]
                const keyValSpacing = (longestKeyLen - key.length) + 4
                const keyValIndent = (' ').repeat(keyValSpacing)

                if (Array.isArray(val)) {
                    if (key === '_lua') {
                        retVal += val.length > 0 ? indent : ''
                        retVal += val.join('\n' + indent)
                        retVal += '\n'
                    } else {
                        val.forEach(subVal => {
                            let block = false
                            if (typeof subVal === 'object') {
                                block = true
                                subVal = ' {\n' + recurse(subVal, depth + 1) + indent + '}\n\n'
                            }
                            const spacing = block ? ' ' : keyValIndent
                            retVal += indent + (key + spacing + subVal).trim()
                            block ? retVal += '\n' : retVal += ';\n'
                        })
                    }
                } else if (typeof val === 'object') {
                    retVal += indent + key + ' {\n'
                    retVal += recurse(val, depth + 1)
                    retVal += indent + '}\n\n'
                } else {
                    retVal += indent + (key + keyValIndent + val).trim() + ';\n'
                }
            }

            return retVal
        }

        return recurse(json, 0)
    }
}

let p = new Parser()

function json_to_conf(json){
    //return p.toConf(gengJSON)
    let result = JSON.parse(json)
    return p.toConf(result)
}

function conf_to_json(conf){
    let tem = p.toJSON(conf);
    if (tem.server.length == undefined){
        tem.server = [tem.server]
    }
    return JSON.stringify(tem)
}


//console.log(p.toConf(gengJSON))
//console.log(p.toJSON(gengConf))
