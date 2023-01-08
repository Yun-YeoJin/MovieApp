//
//  MovieData.swift
//  MovieApp
//
//  Created by 윤여진 on 2022/12/29.
//

import Foundation

import RealmSwift

final class MovieData: Object {
    @Persisted var imdbId: String
    @Persisted var poster: String
    @Persisted var title: String
    @Persisted var year: String
    @Persisted var type: String
    @Persisted var isBookmarked: Bool
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    convenience init(imdbId: String, poster: String, title: String, year: String, type: String, isBookmarked: Bool) {
        self.init()
        
        self.imdbId = imdbId
        self.poster = poster
        self.title = title
        self.year = year
        self.type = type
        self.isBookmarked = isBookmarked
    }
}
