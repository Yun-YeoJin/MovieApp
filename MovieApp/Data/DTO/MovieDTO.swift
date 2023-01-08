//
//  MovieDTO.swift
//  MovieApp
//
//  Created by 윤여진 on 2022/12/27.
//

import Foundation

// MARK: - MovieDTO
struct MovieDTO: Codable {
    
    let movieDetails: [MovieDetail]
    let totalResults, response: String
    
    enum CodingKeys: String, CodingKey {
        case movieDetails = "Search"
        case totalResults
        case response = "Response"
    }
    
}

