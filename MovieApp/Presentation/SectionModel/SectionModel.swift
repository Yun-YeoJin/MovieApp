//
//  SectionModel.swift
//  MovieApp
//
//  Created by 윤여진 on 2022/12/27.
//

import Foundation

import RxDataSources

struct MovieSectionModel: SectionModelType {
    
    var items: [Item]
    
    init(items: [MovieDetail]) {
        self.items = items
    }
    
    typealias Item = MovieDetail
    
    init(original: MovieSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
