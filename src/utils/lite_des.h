#ifndef LITEDES_H
#define LITEDES_H

#include <QByteArray>

class LiteDES {
public:
    // 核心接口：CBC 模式解密与加密 (自带 PKCS#7 填充处理)
    static QByteArray decryptCBC(const QByteArray& cipherText, const QByteArray& key, const QByteArray& iv);
    static QByteArray encryptCBC(const QByteArray& plainText, const QByteArray& key, const QByteArray& iv);

private:
    // DES 核心单块处理 (8字节)
    static void processBlock(const unsigned char* in, unsigned char* out, const unsigned char subKeys[16][8], bool isDecrypt);
    // 生成 16 轮子密钥
    static void generateSubKeys(const unsigned char* key, unsigned char subKeys[16][8]);

    // 基础位操作工具
    static void permute(const unsigned char* in, unsigned char* out, const int* table, int size);
    static void splitKey(const unsigned char* key, unsigned char* c, unsigned char* d);
    static void shiftLeft(unsigned char* block, int shifts);
};

#endif // LITEDES_H