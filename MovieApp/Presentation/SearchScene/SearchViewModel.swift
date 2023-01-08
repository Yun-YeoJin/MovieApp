//
//  SearchViewModel.swift
//  MovieApp
//
//  Created by 윤여진 on 2022/12/27.
//

import Foundation

import RxCocoa
import RxSwift
import RealmSwift

class SearchViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    var movieList: [MovieDetail] = []
    
    let repository = MovieRepository()
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let titleSubject: PublishSubject<String>
        let pageSubject: PublishSubject<Int>
        let searchButtonTap: ControlEvent<Void>
        let bookmarkItem: PublishSubject<MovieDetail>
    }
    
    struct Output {
        var movieData: PublishSubject<[MovieSectionModel]>
    }
    
    func transform(input: Input) -> Output {
        
        let movieData = PublishSubject<[MovieSectionModel]>()
        
        input.viewDidLoadEvent
            .observe(on: SerialDispatchQueueScheduler(qos: .background)) // background Thread
            .subscribe { _ in
                movieData.onNext([])
                self.movieList = []
            }.disposed(by: disposeBag)
        
        input.searchButtonTap
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.movieList = []
                input.pageSubject.onNext(0)
            }.disposed(by: disposeBag)
        
        Observable.combineLatest(input.titleSubject, input.pageSubject)
            .observe(on: SerialDispatchQueueScheduler(qos: .background))
            .flatMap { title, page -> Observable<[MovieDetail]> in
                let observable = self.requestMovies(title: title, page: page)
                return observable
            }
            .subscribe { movieDetails in
                self.movieList.append(contentsOf: movieDetails)
                movieData.onNext([MovieSectionModel(items: self.movieList)])
            }.disposed(by: disposeBag)
        
        input.bookmarkItem
            .observe(on: MainScheduler.instance)
            .subscribe { data in
                let task = MovieData(imdbId: data.element?.imdbID ?? "", poster: data.element?.poster ?? "", title: data.element?.title ?? "", year: data.element?.year ?? "", type: data.element?.type ?? "", isBookmarked: true)
                self.repository.addMovie(task)
            }.disposed(by: disposeBag)
        
        return Output(movieData: movieData)
    }
    
    func requestMovies(title: String, page: Int) -> Observable<[MovieDetail]> {
        
        return Observable<[MovieDetail]>.create { observer in
            MovieAPIService.shared.requestMovieAPI(type: MovieDTO.self, router: MovieRouter.search(title: title, page: "\(page)")) { result in
                switch result {
                case .success(let success):
                    observer.onNext(success.movieDetails)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }.observe(on: SerialDispatchQueueScheduler(qos: .background))
        
    }
    
}
