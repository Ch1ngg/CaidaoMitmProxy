#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import base64
import mitmproxy.http
from mitmproxy import ctx
import pyDes
import random
from urllib.parse import quote


key = "KvCb2poU"
# 加密
def encrypt_str(key,data):
    # 加密方法
    method = pyDes.des(key, pyDes.ECB,pad=None, padmode=pyDes.PAD_PKCS5)
    # 执行加密码
    k = method.encrypt(data)
    # 转base64编码并返回
    return base64.b64encode(k)


# 解密
def decrypt_str(key,data):
    method = pyDes.des(key, pyDes.ECB,pad=None, padmode=pyDes.PAD_PKCS5)
    # 对base64编码解码
    k = base64.b64decode(data)
    # 再执行Des解密并返回
    return method.decrypt(k)

class Counter:

    def __init__(self):
        pass

    def request(self, flow: mitmproxy.http.HTTPFlow):

        ctx.log.info("Original Request Data: %s" % str(flow.request.content))
        flow.request.content = bytes(quote(str(encrypt_str(key.encode(encoding="utf-8"), flow.request.content),encoding="UTF-8")),encoding="UTF-8")
        ctx.log.info("Encrypt Request Data: %s" % str(flow.request.content))

    def response(self,flow: mitmproxy.http.HTTPFlow):
        flow.response.content = decrypt_str(key.encode(encoding="utf-8"),flow.response.content)
        ctx.log.info("Decrypt Response Data: %s" % str(flow.request.content))

addons = [
    Counter()
]

