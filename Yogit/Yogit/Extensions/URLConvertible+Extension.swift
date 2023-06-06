//
//  URLConvertible+Extension.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/15.
//

import Foundation
import Alamofire


extension URLRequestConvertible {
    func mirroringDictionary(parameter: Any) -> [String: Any] {
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
                }
            }
        }
        return dictionary
    }
    
    func multipartAppendParameters(parameters: Parameters) -> MultipartFormData {
        let multipartFormData = MultipartFormData()
        for (key, value) in parameters {
            if let arrayValue = value as? [Any]  {
                if let images = arrayValue as? [UIImage] {
                    for image in images {
                        multipartFormData.append(image.toFile(format: .jpeg(0.7))!, withName: key, fileName: key + ".jpeg", mimeType: key + "/jpeg")
                    }
                } else {
                    if arrayValue.isEmpty {
                        multipartFormData.append(Data("".utf8), withName: key) // 0 byte
                    } else {
                        for element in arrayValue {
                            multipartFormData.append(Data("\(element)".utf8), withName: key)
                        }
                    }
                }
            } else {
                if let image = value as? UIImage {
                    multipartFormData.append(image.toFile(format: .jpeg(0.7))!, withName: key, fileName: key + ".jpeg", mimeType: key + "/jpeg")
                } else {
                    multipartFormData.append(Data("\(value)".utf8), withName: key)
                }
            }
        }
        return multipartFormData
    }
}
