//
//  BookmarkMovieViewModel.swift
//  MovieApp
//
//  Created by 윤여진 on 2022/12/30.
//

import Foundation

import RxCocoa
import RxSwift

class BookmarkMovieViewModel: ViewModelType {
    
    private var disposeBag = DisposeBag()
    
    private let repository = MovieRepository()
    
    struct Input {
        let viewWillAppearEvent: PublishSubject<Bool>
        let triggerEvent: PublishSubject<Bool>
    }
    
    struct Output {
        var movieData: PublishSubject<[MovieSectionModel]>
    }
    
    func transform(input: Input) -> Output {
        
        let movieData = PublishSubject<[MovieSectionModel]>()
        
        Observable.merge(input.viewWillAppearEvent, input.triggerEvent)
            .observe(on: MainScheduler.instance) // Main Thread
            .subscribe { _ in
                let bookmarkedMovies = self.repository.fetch()
                var movieSectionModels: [MovieSectionModel] = []
                var movieDetails: [MovieDetail] = []
                // [MovieData] -> [MovieDetail]
                bookmarkedMovies.forEach {
                    movieDetails.append(MovieDetail(title: $0.title, year: $0.year, imdbID: $0.imdbId, type: $0.type, poster: $0.poster))
                }
                movieSectionModels.append(MovieSectionModel(items: movieDetails))
                movieData.onNext(movieSectionModels)
            }.disposed(by: disposeBag)
        
        return Output(movieData: movieData)
    }
    
}
