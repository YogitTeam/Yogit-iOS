//
//  KeyChainManager.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/29.
//

import Foundation

final class KeychainManager {
    static let shared = KeychainManager()
    
//    enum ServiceUser {
//        static let APPLE_USER: String = "APPLE_USER"
//    }
    
    enum KeychainError: Error {
        case duplicateEntry // keychain data dulicated
        case unexpectedTokenData // unexpected token data type
        case unexpectedUserData // unexpected User data type
        case unhandledError(status: OSStatus) // unknowed: throw OS status
    }
    
    // 사용자 (이메일, 이름) 저장
    static func saveUser(user: User, userType: String) throws { // email, name
        guard let data = try? JSONEncoder().encode(user) else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: userType,
            kSecValueData as String: data
        ]
        
        print("keychain save query \(query)")
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        print("keychain saved")
        print("Read status \(status)")
        
        guard status != errSecDuplicateItem else { throw KeychainError.duplicateEntry }
        
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }
    
    // 사용자 (이메일, 이름) 삭제
    static func deleteUser(userType: String) throws {
        let query: NSDictionary = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: userType
            ]
        let status = SecItemDelete(query)
        print("애플 User type 삭제 미통과")
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        print("애플 User type 삭제 통과")
    }
    
    // 사용자 (이메일, 이름) 조회
    static func getUser(userType: String) throws -> User? { // serviceType: String 인자
        // service, account, return-data, class, matchlimit
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrService as String: serviceType, // 현재 서비스 타입인지 체크
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
        
        guard let existingItem = item as? [String : Any],
            let data = existingItem[kSecValueData as String] as? Data,
            let user = try? JSONDecoder().decode(User.self, from: data)
//            let userType = existingItem[kSecAttrService as String] as? String,
//            let userEmail =  existingItem[kSecAttrAccount as String] as? String
        else {
            print("키체인 User 에러")
            throw KeychainError.unexpectedUserData
        }
        
        print("키체인 통과")
        return user
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
        
        UserDefaults.standard.set(userItem.userType, forKey: SessionManager.currentServiceTypeIdentifier)
        
    }
    
    // 조회
    static func getUserItem(serviceType: String) throws -> UserItem? { // serviceType: String 인자
        // service, account, return-data, class, matchlimit
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceType, // 현재 서비스 타입인지 체크
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
        
        guard let existingItem = item as? [String : Any],
            let data = existingItem[kSecValueData as String] as? Data,
            let userItem = try? JSONDecoder().decode(UserItem.self, from: data)
//            let userType = existingItem[kSecAttrService as String] as? String,
//            let userEmail =  existingItem[kSecAttrAccount as String] as? String
        else {
            print("키체인 에러")
            throw KeychainError.unexpectedTokenData
        }
        
        print("키체인 통과")
        return userItem
    }
    
    // 업데이트
    // 저장된 유저 아이템 기져온 후
    // 해당 유저아이템 변경
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
        
        if userItem.userStatus == SessionManager.AuthState.signOut.rawValue { // 로그아웃이면
            UserDefaults.standard.removeObject(forKey: SessionManager.currentServiceTypeIdentifier) // 앱 로그아웃/삭제 후 로그인(유저 디폴트 삭제됨) 혹은 로그아웃
            UserDefaults.standard.removeObject(forKey: Preferences.PUSH_NOTIFICATION)  // 앱 앱 로그아웃/삭제 후 디바이스 토큰 삭재
        } else if userItem.userStatus == SessionManager.AuthState.signInSNS.rawValue { // 로그인이면
            UserDefaults.standard.set(userItem.userType, forKey: SessionManager.currentServiceTypeIdentifier) // 앱 로그아웃 후 로그인하면 서비스 키값 저장
        }
        
        print("keychain update")
    }
    
//    static func deleteUserItem() throws {
//        let query: NSDictionary = [
//                kSecClass as String: kSecClassGenericPassword,
////                kSecAttrService as String: userItem.userType, // 추가 했으니 체크해야됨
////                kSecAttrAccount as String: userItem.account.user.email, // 추가 했으니 체크해야됨
//            ]
//        let status = SecItemDelete(query)
//
//        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
//        UserDefaults.standard.removeObject(forKey: SessionManager.currentServiceTypeIdentifier) // 앱 삭제후 로그인(유저 디폴트 삭제됨) 혹은 로그아웃
//        UserDefaults.standard.removeObject(forKey: Preferences.PUSH_NOTIFICATION)
////        assert(status == noErr, "failed to delete the value, status code = \(status)")
//    }
    
    static func deleteUserItem(userItem: UserItem) throws {
        let query: NSDictionary = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: userItem.userType, // 추가 했으니 체크해야됨
                kSecAttrAccount as String: userItem.account.user.email, // 추가 했으니 체크해야됨
            ]
        let status = SecItemDelete(query)
        print("유저 계정 삭제 미통과")
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        print("유저 계정 삭제 통과")
        UserDefaults.standard.removeObject(forKey: SessionManager.currentServiceTypeIdentifier) // 앱 삭제후 로그인(유저 디폴트 삭제됨) 혹은 로그아웃
        UserDefaults.standard.removeObject(forKey: Preferences.PUSH_NOTIFICATION) // 앱 삭제후 디바이스 토큰 삭제
//        assert(status == noErr, "failed to delete the value, status code = \(status)")
    }
}
