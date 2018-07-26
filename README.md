# LiveDemo
A demo of live that used IJKPlayer &amp; LFLiveKit


# Part I - Install Nginx & Nginx-Rtmp module 

`1. 下载所需源码及组件`
*   nginx: [http://nginx.org/download/nginx-1.12.2.tar.gz](http://nginx.org/download/nginx-1.12.2.tar.gz)
*   zlib: [http://zlib.net/zlib-1.2.11.tar.gz](http://zlib.net/zlib-1.2.11.tar.gz)
*   pcre: https://ftp.pcre.org/pub/pcre/
*   openssl: [https://www.openssl.org/source/openssl-1.1.0g.tar.gz](https://www.openssl.org/source/openssl-1.1.0g.tar.gz)

`2. 将下载的所有压缩包放入同一个文件夹中, 并一一解压`
```
tar -zxvf nginx-1.12.2.tar.gz

tar -zxvf zlib-1.2.11.tar.gz

tar -zxvf pcre-8.38.tar.gz

tar -zxvf openssl-1.1.0g.tar.gz
```
`3. 进入nginx文件夹内, 依次输入命令`
```
./configure --prefix=/usr/local/nginx --with-zlib=../zlib-1.2.11 --with-pcre=../pcre-8.38 --with-openssl=../openssl-1.1.0g
```
```
make
sudo make install
```

`4. 安装rtmp组件: 下载并放入刚才的同一文件夹中`
 [nginx-rtmp-module](https://github.com/arut/nginx-rtmp-module)
```
./configure --add-module=../nginx-rtmp-module
make
sudo make install
```
`5. Nginx的启停`

* 启动
`sudo /usr/local/nginx/sbin/nginx`

* 关闭
`sudo /usr/local/nginx/sbin/nginx -s stop`

* 重启
`sudo /usr/local/nginx/sbin/nginx -s reload`

# Part II - Install FFmpeg & Test Pull Stream
*  修改nginx配置文件
进入nginx配置文件目录,修改nginx.conf文件:
```
vi /usr/local/nginx/conf/nginx.conf
```
* 在http节点后添加rtmp (real time message protocol)配置
```
rtmp {
    server {
        listen 1935;
        application rtmplive {
            live on;
            record off;
        }
    }
}
```

* 下载安装VLC播放器[链接](https://www.videolan.org/vlc/)
* 安装ffmpeg
```
brew install ffmpeg
```
* 测试
1. 将视频test.mp4放在桌面
2. 开启nginx: `sudo /usr/local/nginx/sbin/nginx`
3. 使用ffmpeg推流:
```
ffmpeg -re -i /Users/qooapp/Desktop/test.mp4 -vcodec libx264 -acodec aac -strict -2 -f flv rtmp://localhost:1935/rtmplive/room
```
4. 打开VLC播放器, 选择 [File] -> [Open Network], 输入`rtmp://localhost:1935/rtmplive/room`

5. 右键该链接选择[play] 播放按钮

# Part III - Push Stream 
* 第三方框架: [LFLiveKit](https://github.com/LaiFengiOS/LFLiveKit)
* 访问本地服务器时要注意: 
  1. 手机和服务器(自己的Mac)使用同一wifi, 或在同一网段内
  2. 手机wifi设置代理, 代理服务器地址为Mac的IP地址, 端口号80
  3. Mac关闭防火墙 : [安全/隐私] -> [防火墙] 