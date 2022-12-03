//
//  KeyChainManager.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/29.
//

import Foundation

final class KeychainManager {
    static let shared = KeychainManager()
    
    enum KeychainError: Error {
        case duplicateEntry // keychain data dulicated
        case unexpectedTokenData // unexpected token data type
        case unhandledError(status: OSStatus) // unknowed: throw OS status
    }
    
    static func saveUserItem(userItem: UserItem) throws {
        guard let data = try? JSONEncoder().encode(userItem) else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: userItem.userType, // service name
            kSecAttrAccount as String: userItem.account.user.email, // user email (private key)
            kSecValueData as String: data
        ]
        
        print("keychain save query \(query)")
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        print("keychain saved")
        print("Read status \(status)")
        
        guard status != errSecDuplicateItem else { throw KeychainError.duplicateEntry }
        
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }
    
    // 조회
    static func getUserItem() throws -> UserItem? {
        // service, account, return-data, class, matchlimit
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecMatchLimit as String: kSecMatchLimitOne, // 중복시 한개의 가
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item) // get
        
        print("get Item \(String(describing: item))")
        print("get query \(query)")
        
        guard status != errSecItemNotFound else { return nil }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
        print("Read status \(status)")

        guard let existingItem = item as? [String : Any],
            let data = existingItem[kSecValueData as String] as? Data,
            let userItem = try? JSONDecoder().decode(UserItem.self, from: data)
//            let userType = existingItem[kSecAttrService as String] as? String,
//            let userEmail =  existingItem[kSecAttrAccount as String] as? String
        else {
            throw KeychainError.unexpectedTokenData
        }
        
        print(userItem)
        
        return userItem
    }
    
    // 업데이트
    static func updateUserItem(userItem: UserItem) throws {
        guard let data = try? JSONEncoder().encode(userItem) else { return }
        print("keychain save data \(data)")
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: userItem.userType,
            kSecAttrAccount as String: userItem.account.user.email,
            kSecValueData as String: data
        ]
        
        print("save userItem \(userItem)")
        print("save query \(query)")
        
       // new query
        let item: [String: Any] = [
            kSecAttrService as String: userItem.userType,
            kSecAttrAccount as String: userItem.account.user.email,
            kSecValueData as String: data
        ]
        
        let status = SecItemUpdate(query as CFDictionary, item as CFDictionary) // save
        
        print("Read status \(status)")
        
        guard status != errSecItemNotFound else { return }
        
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
        print("keychain update")
    }
    
    static func deleteUserItem() throws {
        let query: NSDictionary = [
                kSecClass as String: kSecClassGenericPassword,
//                kSecAttrService as String: userType // service name
            ]
        let status = SecItemDelete(query)
        
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
//        assert(status == noErr, "failed to delete the value, status code = \(status)")
    }
     
}
