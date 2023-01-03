//
//  fileOperations.swift
//  genglearn
//
//  Created by geng on 2022/12/16.
//

import Foundation

// create folder at spicific location
func createFolderGeng(name: String, baseUrl: NSURL) {
    let manager = FileManager.default
    let folder = baseUrl.appendingPathComponent(name, isDirectory: true)
    print("folder: \(folder!)")
    let exist = manager.fileExists(atPath: folder!.path)
    if !exist {
        try! manager.createDirectory(at: folder!, withIntermediateDirectories: true,
                                     attributes: nil)
    } else {
        print("folder exist")
    }
}

// create file at spicific location
func createEmptyFileGeng(name: String, fileBaseUrl: URL) {
    let manager = FileManager.default

    let file = fileBaseUrl.appendingPathComponent(name)
    print("file: \(file)")
    let exist = manager.fileExists(atPath: file.path)
    if !exist {
        let data = Data(base64Encoded: "", options: .ignoreUnknownCharacters)
        let createSuccess = manager.createFile(atPath: file.path, contents: data, attributes: nil)
        print("file result: \(createSuccess)")
    } else {
        print("file exist")
    }
}

func copyFileGeng(source: URL, to: URL) {
    do {
        if FileManager.default.fileExists(atPath: to.path) {
            try FileManager.default.removeItem(at: to)
        }
        try FileManager.default.copyItem(at: source, to: to)
    } catch let error {
        print("Cannot copy item at \(source) to \(to): \(error)")
    }
}

func deleteFileGeng(source: URL) {
    do {
        if FileManager.default.fileExists(atPath: source.path) {
            try FileManager.default.removeItem(at: source)
        } else {
            print("file not exist")
        }
    } catch let error {
        print("Cannot delete item at \(source) : \(error)")
    }
}

func deleteFolderGeng(source: URL) {
    deleteFileGeng(source: source)
}

func readFileGeng(source: URL) {
    do {
        let readHandler = try FileHandle(forReadingFrom: source)
        let data = readHandler.readDataToEndOfFile()
        let readString = String(data: data, encoding: String.Encoding.utf8)
        print("file-content: \(readString ?? "empty file")")
    } catch let error {
        print("Error at \(source) : \(error)")
    }
}

func writeFileGeng(source: URL,content:String, startOrEnd:String = "override") {
    var isNewFile = false
    if !FileManager.default.fileExists(atPath: source.path) {
        FileManager.default.createFile(atPath: source.path, contents: nil, attributes: nil)
        isNewFile = true
    }

    let fileHandle = FileHandle(forWritingAtPath: source.path)!
    if startOrEnd == "override" {
       
        try? fileHandle.truncate(atOffset: 0)
        fileHandle.write(content.data(using: .utf8)!)
    } else {
        fileHandle.seekToEndOfFile()
        var newContent = ""
        newContent = isNewFile ? content: ("\n\n" + content)
        
        fileHandle.write(newContent.data(using: .utf8)!)
        print("hehe2")
    }
    
    try? fileHandle.close()
    
    /*
    if let contentInner = try? String(contentsOfFile: source.path, encoding: .utf8) {
        print(contentInner)
    }
     */
}

func getFilePermissionGeng(source: URL) {
    let manager = FileManager.default

    let readable = manager.isReadableFile(atPath: source.path)
    print("read: \(readable)")
    let writeable = manager.isWritableFile(atPath: source.path)
    print("wirte: \(writeable)")
    let executable = manager.isExecutableFile(atPath: source.path)
    print("exec: \(executable)")
    let deleteable = manager.isDeletableFile(atPath: source.path)
    print("delete: \(deleteable)")
}

// createFolder(name: "niu", baseUrl: NSURL(fileURLWithPath: "/usr/local/etc/nginx/servers"))
// createEmptyFile(name: "b.txt", fileBaseUrl: URL(fileURLWithPath: "/usr/local/etc/nginx/servers"))
// copyFile(source: URL(fileURLWithPath: "/Users/geng/Desktop/others/a.txt"), to: URL(fileURLWithPath: "/usr/local/etc/nginx/servers/xiao.txt"))
// deleteFile(source: URL(fileURLWithPath: "/Users/geng/Desktop/others/a.txt"))
// deleteFolder(source: URL(fileURLWithPath: "/usr/local/etc/nginx/servers/niu"))
// readFile(source: URL(fileURLWithPath: "/usr/local/etc/nginx/servers/diao2.txt"))

// writeFile(
//  source: URL(fileURLWithPath: "/usr/local/etc/nginx/servers/diao2.txt"),
// content: "lao niu bi le",
// startOrEnd: "append"
// )
