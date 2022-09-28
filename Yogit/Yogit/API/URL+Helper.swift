//
//  URL+Helper.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/28.
//

import Foundation

// URLComponents
// 정확한 문자열 구성 어려움 > URLComponents을 이용해서 쿼리를 구성
// 쿼리 받게 extension
// 파라메터로 넘어온 모든 딕션너리를 url queryitem instance로 변경이 핵심
extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true) // url 자체를 받고 baseurl 기반으로 쓰도록
        // 컨포넌트 쿼리아이템 생성
        components?.queryItems = queries.map { URLQueryItem(name: $0.0, value: $0.1) }
            return components?.url // 컨포넌트 url 반환
    }
}
