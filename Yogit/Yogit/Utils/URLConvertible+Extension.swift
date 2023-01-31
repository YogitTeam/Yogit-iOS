//
//  URLConvertible+Extension.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/15.
//

import Foundation
import Alamofire

extension URLConvertible {
    func mirroringDictionary(parameter: Any) -> [String: Any]?  {
        let mirror = Mirror(reflecting: parameter)
        var dictionary = [String: Any]()
        for child in mirror.children {
            if let label = child.label {
                if let value = child.value as? Optional<[Any]> {
                    if let unwrappedValue = value {
                        dictionary[label] = unwrappedValue
                    }
//                    else {
//                        dictionary[label] = nil
//                    }
                } else if let value = child.value as? Optional<Any> {
                    if let unwrappedValue = value {
                        dictionary[label] = unwrappedValue
                    }
//                    if let value = child.value as? Optional<Any> {
//                        if let unwrappedValue = value {
//                            dictionary[label] = unwrappedValue
//                        }
//                    }
                }
            }
        }
        return dictionary
    }
}

extension URLRequestConvertible {
    func mirroringDictionary(parameter: Any) -> [String: Any]?  {
        let mirror = Mirror(reflecting: parameter)
        var dictionary = [String: Any]()
        for child in mirror.children {
            if let label = child.label {
                if let value = child.value as? Optional<[Any]> {
                    if let unwrappedValue = value {
                        dictionary[label] = unwrappedValue
                    }
//                    else {
//                        dictionary[label] = nil
//                    }
                } else if let value = child.value as? Optional<Any> {
                    if let unwrappedValue = value {
                        dictionary[label] = unwrappedValue
                    }
//                    if let value = child.value as? Optional<Any> {
//                        if let unwrappedValue = value {
//                            dictionary[label] = unwrappedValue
//                        }
//                    }
                }
            }
        }
        return dictionary
    }
}
