//
//  configData.swift
//  genglearn
//
//  Created by geng on 2022/12/24.
//

import Foundation

let homePath = FileManager.default.homeDirectoryForCurrentUser.path
struct configData {
    static var basicNginx =
        """
        server {
            listen       8686;
            server_name  localhost;
            root         \(homePath)/Desktop/gengphp;
            index index.php index.html index.htm;

            location / {
                try_files $uri $uri/ /index.php?$query_string;
            }

            error_page   500 502 503 504  /50x.html;
            location = /50x.html {
                root   html;
            }
            location ~ \\.php$ {
                fastcgi_pass   127.0.0.1:9000;
                fastcgi_index  index.php;
                fastcgi_param SCRIPT_FILENAME  $document_root$fastcgi_script_name;
                include        fastcgi_params;
            }
        }
        """
    
    static var moreNginx =
        """
        server {
            listen       8819;
            server_name  localhost;
            root         \(homePath)/Desktop/gengphp;
            index index.php index.html index.htm;

            location / {
                try_files $uri $uri/ /index.php?$query_string;
            }

            error_page   500 502 503 504  /50x.html;
            location = /50x.html {
                root   html;
            }
            location ~ \\.php$ {
                fastcgi_pass   127.0.0.1:9000;
                fastcgi_index  index.php;
                fastcgi_param SCRIPT_FILENAME  $document_root$fastcgi_script_name;
                include        fastcgi_params;
            }
        }
        
        server {
            listen       8820;
            server_name  localhost;
            root         \(homePath)/Desktop/gengphp;
            index index.php index.html index.htm;

            location / {
                try_files $uri $uri/ /index.php?$query_string;
            }

            error_page   500 502 503 504  /50x.html;
            location = /50x.html {
                root   html;
            }
            location ~ \\.php$ {
                fastcgi_pass   127.0.0.1:9000;
                fastcgi_index  index.php;
                fastcgi_param SCRIPT_FILENAME  $document_root$fastcgi_script_name;
                include        fastcgi_params;
            }
        }
        """
}
