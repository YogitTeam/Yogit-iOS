//
//  KeyChainManager.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/29.
//

import Foundation

// 공통 유저 계정 모델 CRUD
private protocol UserItemAPICall {
    static func saveUserItem(userItem: UserItem) throws
    static func getUserItem(serviceType: String) throws -> UserItem?
    static func updateUserItem(userItem: UserItem) throws // 저장된 유저 아이템 기져온 후 해당 유저아이템 변경
    static func deleteUserItem(userItem: UserItem) throws
}

// 애플 초기 인증시 사용자 (이메일, 이름) 한번만 제공하여, 해당 프로퍼티 관리
private protocol UserInitAPICall {
    func saveUser(user: User, userType: String) throws
    func deleteUser(userType: String) throws
    func getUser(userType: String) throws -> User?
}

final class KeychainManager {
    static let shared = KeychainManager()
    
    enum KeychainError: Error {
        case duplicateEntry // keychain data dulicated
        case unexpectedTokenData // unexpected token data type
        case unexpectedUserData // unexpected User data type
        case unhandledError(status: OSStatus) // unknowed: throw OS status
    }
}

extension KeychainManager: UserItemAPICall {
    static func saveUserItem(userItem: UserItem) throws {
        guard let data = try? JSONEncoder().encode(userItem) else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: userItem.userType, // service name
            kSecAttrAccount as String: userItem.account.user.email, // user email
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else { throw KeychainError.duplicateEntry }
        
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
        print("Keychain Save UserItem")
    }
    
    static func getUserItem(serviceType: String) throws -> UserItem? {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceType, // 현재 서비스 타입인지 체크
            kSecMatchLimit as String: kSecMatchLimitOne, // 중복시 한개의 아이템 반환
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item) // get
        
        guard status != errSecItemNotFound else { return nil }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
        guard let existingItem = item as? [String : Any],
            let data = existingItem[kSecValueData as String] as? Data,
            let userItem = try? JSONDecoder().decode(UserItem.self, from: data)
        else {
            throw KeychainError.unexpectedTokenData
        }
        
        print("Keychain Get UserItem")
        
        return userItem
    }
    
    static func updateUserItem(userItem: UserItem) throws {
        guard let data = try? JSONEncoder().encode(userItem) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: userItem.userType,
            kSecAttrAccount as String: userItem.account.user.email,
            kSecValueData as String: data
        ]
        
       // new query
        let item: [String: Any] = [
            kSecAttrService as String: userItem.userType,
            kSecAttrAccount as String: userItem.account.user.email,
            kSecValueData as String: data
        ]
        
        let status = SecItemUpdate(query as CFDictionary, item as CFDictionary) // save
        
        guard status != errSecItemNotFound else { return }
        
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
        print("Keychain Update UserItem")
    }
    
    static func deleteUserItem(userItem: UserItem) throws {
        let query: NSDictionary = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: userItem.userType, // 추가 했으니 체크해야됨
                kSecAttrAccount as String: userItem.account.user.email, // 추가 했으니 체크해야됨
            ]
        
        let status = SecItemDelete(query)

        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
        print("Keychain Delete UserItem")
    }
}

extension KeychainManager: UserInitAPICall {
    func saveUser(user: User, userType: String) throws {
        guard let data = try? JSONEncoder().encode(user) else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrService as String: userType,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else { throw KeychainError.duplicateEntry }
        
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
        print("Keychain Save User")
    }
    
    func deleteUser(userType: String) throws {
        let query: NSDictionary = [
                kSecClass as String: kSecClassKey,
                kSecAttrService as String: userType
            ]
        let status = SecItemDelete(query)
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
        print("Keychain Delete User")
    }
    
    func getUser(userType: String) throws -> User? {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrService as String: userType, // 현재 서비스 타입인지 체크
            kSecMatchLimit as String: kSecMatchLimitOne, // 중복시 한개의 아이템 반환
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var item: AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &item) 
        
        guard status != errSecItemNotFound else { return nil }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
        guard let existingItem = item as? [String : Any],
            let data = existingItem[kSecValueData as String] as? Data,
            let user = try? JSONDecoder().decode(User.self, from: data)
        else {
            throw KeychainError.unexpectedUserData
        }

        print("Keychain Get User")
        
        return user
    }
}
