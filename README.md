采用协程来并发的下载文件

文件放置位置 /home/nginx/conf/scripts/

配置指令
location /download {
    content_by_lua_file 'conf/scripts/download.lua';
}

访问样例
curl localhost/download

/test.txt 32248
/test1.txt 48264
/test2.txt 43259
/test3.txt 52268
