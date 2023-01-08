//
//  MovieRepository.swift
//  MovieApp
//
//  Created by 윤여진 on 2022/12/29.
//

import Foundation

import RealmSwift

protocol MovieRepositoryType {
    func fetch() -> Results<MovieData>
    func addMovie(_ item: MovieData)
    func deleteMovie(_ item: MovieData)
}

final class MovieRepository: MovieRepositoryType {
    
    let config = Realm.Configuration(schemaVersion: 1)
    lazy var localRealm = try! Realm(configuration: config)
    
    func fetch() -> Results<MovieData> {
        return localRealm.objects(MovieData.self)
    }
    
    func addMovie(_ item: MovieData) {
        try! self.localRealm.write {
            self.localRealm.add(item)
        }
    }
    
    func deleteMovie(_ item: MovieData) {
        try! self.localRealm.write {
            self.localRealm.delete(item)
        }
    }
}
