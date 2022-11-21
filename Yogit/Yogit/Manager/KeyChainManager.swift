////
////  KeyChainManager.swift
////  Yogit
////
////  Created by Junseo Park on 2022/09/29.
////
//
//import Foundation
//
////struct Account {
////    let userName: String?
////    let userEmail: String?
////    let userIdentifier: String
////    let userId: Int
////}
////
////struct UserItem {
////    let accunt: Account
////    var service: String
////    let token: String
////}
//
//final class KeychainManager {
//    static let shared = KeychainManager()
//    
//    enum KeychainError: Error {
//        case duplicateEntry // keychain data dulicated
//        case unexpectedTokenData // unexpected token data type
//        case unhandledError(status: OSStatus) // unknowed: throw OS status
//    }
//     
//    // 저장
//    static func saveUserItem(userItem: UserItem) throws {
//        // class, service, account (user email & full Name), token (refesh token)
//        let service = userItem.service
//        let account = userItem.accunt
//        let token = userItem.refresh_token.data(using: String.Encoding.utf8)!
//        
//        let query: [String: Any] = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrService as String: service,
//            kSecAttrAccount as String: account,
//            kSecValueData as String: token
//        ]
//        
//        let status = SecItemAdd(query as CFDictionary, nil)
//        
//        print("Read status \(status)")
//        
//        guard status != errSecDuplicateItem else { throw KeychainError.duplicateEntry }
//        
//        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
//    }
//    
//    // 조회
//    static func getUserItem() throws -> UserItem? {
//        // service, account, return-data, class, matchlimit
//        
//        let query: [String: Any] = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecMatchLimit as String: kSecMatchLimitOne, // 중복시 한개의 가
//            kSecReturnAttributes as String: true,
//            kSecReturnData as String: true
//        ]
//        
//        var item: AnyObject?
//        let status = SecItemCopyMatching(query as CFDictionary, &item)
//        
//        guard status != errSecItemNotFound else { return nil }
//        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
//        
//        print("Read status \(status)")
//        
//        guard let existingItem = item as? [String : Any],
//            let tokenData = existingItem[kSecValueData as String] as? Data,
//            let token = String(data: tokenData, encoding: String.Encoding.utf8),
//            let account = existingItem[kSecAttrAccount as String] as? Account,
//            let service = existingItem[kSecAttrService as String] as? String
//        else {
//            throw KeychainError.unexpectedTokenData
//        }
//        
//        // 변경 요구 데이터 변경됨
//        let userItem = UserItem(accunt: account, service: service, token: token)
//        
//        return userItem
//    }
//     
//}
