//
//  SearchDTO.swift
//  MovieApp
//
//  Created by 윤여진 on 2022/12/27.
//

import Foundation

// MARK: - MovieDetail
struct MovieDetail: Codable {
    
    let title, year, imdbID: String
    let type: TypeEnum.RawValue
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}

enum TypeEnum: String, Codable {
    case game
    case movie
    case series
}
