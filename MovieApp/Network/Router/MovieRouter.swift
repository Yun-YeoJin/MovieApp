//
//  MovieRouter.swift
//  MovieApp
//
//  Created by 윤여진 on 2022/12/27.
//

import Foundation
import Alamofire

enum MovieRouter: URLRequestConvertible {
    
    case search(title: String, page: String)
    
    var url: URL {
        switch self {
        case .search(title: let title, page: let page):
            return URL(string: EndPoint.baseURL)!
                .withQuery(param: ["apikey": APIKey.omdbapi, "s": title, "page": page])!
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .search(_, _):
            return [
                "Content-Type": APIHeader.jsonType
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .search(_, _):
            return .get
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = url
        var request = URLRequest(url: url)
        print(request)
        request.headers = header
        request.method = method
        switch self {
        case .search:
            return request
        }
    }
}


