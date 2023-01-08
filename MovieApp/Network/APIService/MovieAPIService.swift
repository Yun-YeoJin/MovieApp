//
//  MovieAPIService.swift
//  MovieApp
//
//  Created by 윤여진 on 2022/12/27.
//

import Foundation
import Alamofire

class MovieAPIService {
    
    static let shared = MovieAPIService()
    
    private init() { }
    
    func requestMovieAPI<T: Codable>(type: T.Type = T.self
                                     ,router: URLRequestConvertible
                                     ,completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(router).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(_):
                guard let statusCode = response.response?.statusCode else { return }
                guard let error = SearchError(rawValue: statusCode) else { return }
                completion(.failure(error))
            }
        }
    }
}
