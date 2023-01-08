//
//  URL+Extension.swift
//  MovieApp
//
//  Created by 윤여진 on 2022/12/27.
//

import Foundation

extension URL {
    
    //appending은 withQuery로 추가하고 마지막에 추가할 때만 쓰려고 남겨둠!!!
    func appending(_ queryItem: String, value: String?) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        let queryItem = URLQueryItem(name: queryItem, value: value)
        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
    
    func withQuery(param: [AnyHashable: Any]) -> URL? {
        var component = URLComponents(url: self, resolvingAgainstBaseURL: true)
        component?.queryItems = []
        param.forEach { item in
            if let key = item.key as? String,
               let value = item.value as? String {
                let query = URLQueryItem(name: key, value: value)
                component?.queryItems?.append(query)
            }
        }
        return component?.url
    }
    
}
