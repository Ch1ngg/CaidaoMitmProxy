# CaidaoMitmProxy
基于HTTP代理中转菜刀过WAF,基于菜刀20160622版本修改和测试。理论上是支持低版本菜刀。本人没测试希望大家来帮忙测试下。

## 安装
* pip[3] install pydes
* pip[3] install mitmproxy

## 使用
* 1.替换 caidao.conf 文件
* 2.Windows: mitmdump -k -s 插件路径
* 3.Linux: mitmproxy -k -s 插件路径

![](/img/ROE8ZV8U_2@91.jpg)

## Shell
- [√] PHP
- [√] JSP
- [×] ASPX
- [×] ASP

## 注意事项
需要替换 20160622 版本的 caidao.conf 文件。文件在 caidaoconf 目录。
没有测试是否支持HTTPS
