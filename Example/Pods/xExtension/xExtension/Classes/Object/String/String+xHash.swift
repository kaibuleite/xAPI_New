//
//  String+xHash.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation
import CommonCrypto

extension String {
    
    // MARK: - 枚举:SHA哈希类型
    /// SHA哈希类型枚举
    public enum xSHAAlgorithmType
    {
        /// 摘要类型
        case SHA1, SHA224, SHA256, SHA384, SHA512
        /// 其对应的摘要长度值
        var digestLength : Int {
            var len: Int32 = 0
            switch self {
            case .SHA1:     len = CC_SHA1_DIGEST_LENGTH
            case .SHA224:   len = CC_SHA224_DIGEST_LENGTH
            case .SHA256:   len = CC_SHA256_DIGEST_LENGTH
            case .SHA384:   len = CC_SHA384_DIGEST_LENGTH
            case .SHA512:   len = CC_SHA512_DIGEST_LENGTH
            }
            return Int(len)
        }
    }
    
    // MARK: - 枚举:HMAC加密类型
    /// HMAC加密类型枚举
    public enum xHMACAlgorithmType
    {
        /// 摘要类型
        case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
        /// 其对应的摘要长度值
        var digestLength : Int {
            var len: Int32 = 0
            switch self {
            case .MD5:      len = CC_MD5_DIGEST_LENGTH
            case .SHA1:     len = CC_SHA1_DIGEST_LENGTH
            case .SHA224:   len = CC_SHA224_DIGEST_LENGTH
            case .SHA256:   len = CC_SHA256_DIGEST_LENGTH
            case .SHA384:   len = CC_SHA384_DIGEST_LENGTH
            case .SHA512:   len = CC_SHA512_DIGEST_LENGTH
            }
            return Int(len)
        }
        /// 散列使用的算法类型
        var hmacAlgorithm : CCHmacAlgorithm {
            var alg: Int = 0
            switch self {
            case .MD5:      alg = kCCHmacAlgMD5
            case .SHA1:     alg = kCCHmacAlgSHA1
            case .SHA224:   alg = kCCHmacAlgSHA224
            case .SHA256:   alg = kCCHmacAlgSHA256
            case .SHA384:   alg = kCCHmacAlgSHA384
            case .SHA512:   alg = kCCHmacAlgSHA512
            }
            return CCHmacAlgorithm(alg)
        }
    }
    
    // MARK: - MD5加密
    /// MD5加密
    /// - Parameter salt: 加盐字符串，默认为空字符串
    /// - Returns: 加密后的字符串
    public func xToMD5String(salt : String = "") -> String
    {
        // 加盐处理后的字符串
        let str = String(format: "%@%@", self, salt)
        let cStr = str.cString(using: .utf8)
        let len = CC_LONG(str.lengthOfBytes(using: .utf8))
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: length)
        CC_MD5(cStr, len, buffer)
        // 解析结果
        var ret = ""
        for i in 0 ..< length {
            let str = String(format: "%02x", buffer[i])
            ret.append(str)
        }
        free(buffer)
        return ret
    }
    
    // MARK: - SHA加密
    /// SHA加密
    /// - Parameters:
    ///   - type: 加密算法类型，具体参考枚举内容
    ///   - salt: 加盐字符串，默认为空字符串
    /// - Returns: 加密后的字符串
    public func xToSHAString(type : xSHAAlgorithmType,
                             salt : String = "") -> String
    {
        // 加盐处理后的字符串
        let str = String(format: "%@%@", self, salt)
        let cStr = str.cString(using: .utf8)
        let len = CC_LONG(str.lengthOfBytes(using: .utf8))
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: type.digestLength)
        // 根据指定的类型进行加密
        switch type {
            case .SHA1:     CC_SHA1(cStr, len, buffer)
            case .SHA224:   CC_SHA224(cStr, len, buffer)
            case .SHA256:   CC_SHA256(cStr, len, buffer)
            case .SHA384:   CC_SHA384(cStr, len, buffer)
            case .SHA512:   CC_SHA512(cStr, len, buffer)
        }
        // 解析结果
        var ret = ""
        for i in 0 ..< type.digestLength {
            let str = String(format: "%02x", buffer[i])
            ret.append(str)
        }
        free(buffer)
        return ret
    }
    
    // MARK: - HMAC加密
    /// HMAC加密
    /// - Parameters:
    ///   - type:  加密算法类型，具体参考枚举内容
    ///   - key: 密钥
    /// - Returns: 加密后的字符串
    public func xToHMACString(type : xHMACAlgorithmType,
                              key : String) -> String
    {
        // 加密内容指针和长度
        let cStr = self.cString(using: .utf8)
        let len = Int(self.lengthOfBytes(using: .utf8))
        // 明文秘钥指针长度
        let cStrKey = key.cString(using: .utf8)
        let lenKey = Int(key.lengthOfBytes(using: .utf8))
        // 结果缓存区
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: type.digestLength)
        // 加密
        CCHmac(type.hmacAlgorithm, cStrKey, lenKey, cStr, len, buffer)
        // 解析结果
        var ret = ""
        for i in 0 ..< type.digestLength {
            let str = String(format: "%02x", buffer[i])
            ret.append(str)
        }
        // 释放内存
        free(buffer)
        return ret
    }
    
}
