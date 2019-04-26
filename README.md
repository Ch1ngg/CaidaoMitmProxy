# CaidaoMitmProxy
基于HTTP代理中转菜刀过WAF,基于菜刀20160622版本修改和测试。理论上是支持低版本菜刀。本人没测试希望大家来帮忙测试下。
## 安装
* pip[3] install pydes
* pip[3] install mitmproxy

## 使用

1. 替换 caidao.conf 文件(使用 PHP DES 加密脚本的时候才需要替换)
2. 将支持 DES 加密的 Webshell 上传到服务器的 Web目录
3. 运行下列代码开启代理中转(使用 -p 可以自定以端口)
```c
Windows：mitmdump -k -s 插件路径
Linux：mitmproxy -k -s 插件路径
```
4. 用Proxifier等其他工具将菜刀或者域名加进代理规则即可。默认监听是8080
5. 用菜刀直接连接就能开始食用啦
![](/img/ROE8ZV8U_2@91.jpg)

## Shell
- [√] PHP
- [√] JSP
- [√] ASPX
- [×] ASP

## 注意事项
需要替换 20160622 版本的 caidao.conf 文件。文件在 caidaoconf 目录。
HTTP代理中转没有测试是否支持HTTPS

## 参考

>https://xz.aliyun.com/t/2739
>
>https://github.com/ekgg/Caidao-AES-Version
