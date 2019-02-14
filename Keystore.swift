//
//  Keystore.swift
//  Keystore
//
//  Created by Christian Rönningen on 2019-02-14.
//

import Foundation

import CryptoSwift

public enum KeystoreResult<Value: Equatable, Error: Equatable> {
    case success(Value?)
    case error(Error)
}

extension KeystoreResult: Equatable { }
extension KeystoreResult {
    public var isError: Bool {
        if case .error(_) = self {
            return true
        } else {
            return false
        }
    }
}

public class Keystore {
    private let accessGroup: String?
    public init(accessGroup: String?) {
        self.accessGroup = accessGroup
    }
    
    public func savePassword(_ password: String, for account: String) -> KeystoreResult<String, OSStatus> {
        guard password.isEmpty == false else {
            return KeystoreResult.error(-1)
        }
        
        let passwordData = password.data(using: .utf8)!
        var attributes: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                         kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked,
                                         kSecAttrAccount as String: account,
                                         kSecValueData as String: passwordData]
        if let accessGroup = accessGroup {
            attributes[kSecAttrAccessGroup as String] = accessGroup
        }
        
        let status = SecItemAdd(attributes as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            return KeystoreResult.error(status)
        }
        return KeystoreResult.success(nil)
    }

    public func encryptAndSavePassword(_ password: String, salt: Array<UInt8>?, for account: String) -> KeystoreResult<String, OSStatus> {
        guard password.isEmpty == false else {
            return KeystoreResult.error(-1)
        }

        if let encrypted = try? HKDF(password: Array(password.utf8), salt: salt, variant: HMAC.Variant.sha256).calculate().toHexString() {
            return savePassword(encrypted, for: account)
        } else {
            return KeystoreResult.error(-1)
        }
    }
    
    public func retrievePassword(for account: String) -> KeystoreResult<String, OSStatus> {
        var query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnData as String: kCFBooleanTrue]
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        var result: AnyObject? = nil
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard let data = result as? Data else {
            return KeystoreResult.error(status)
        }
        
        return KeystoreResult.success(String(data: data, encoding: .utf8))
    }
    
    public func deletePassword(for account: String) -> KeystoreResult<String, OSStatus> {
        var query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account]
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else {
            return KeystoreResult.error(status)
        }
        
        return KeystoreResult.success(nil)
    }
}
