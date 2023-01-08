//
//  BookmarkMovieVC.swift
//  MovieApp
//
//  Created by 윤여진 on 2022/12/27.
//

import UIKit

import Kingfisher
import RxCocoa
import RxSwift
import RxDataSources
import RealmSwift

final class BookmarkMovieVC: BaseViewController {
    
    private let mainView = BookmarkMovieView()
    private let viewModel = BookmarkMovieViewModel()
    private var disposeBag = DisposeBag()
    private let alert = CustomAlertView()
    private let repository = MovieRepository()
    
    private var dataSources = RxCollectionViewSectionedReloadDataSource<MovieSectionModel>(configureCell: { dataSource, collectionView, indexPath, item in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reusableIdentifier, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        cell.onData.onNext(item)
        cell.isBookmarkedButton.setImage(UIImage(named: "bookmark.fill"), for: .normal)
        return cell
    })
    
    lazy var input = BookmarkMovieViewModel.Input(viewWillAppearEvent: PublishSubject<Bool>(), triggerEvent: PublishSubject<Bool>())
    
    lazy var output = viewModel.transform(input: input)
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.viewWillAppearEvent.onNext(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavTitle()
        mainView.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        mainView.collectionView.collectionViewLayout = collectionViewLayout()
        bindRX()
        
    }
    
    private func configureNavTitle() {
        self.navigationItem.title = "내 즐겨찾기"
    }
    
    private func bindRX() {
        
        output.movieData
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.collectionView.rx.items(dataSource: dataSources))
            .disposed(by: disposeBag)
        
        output.movieData
            .observe(on: MainScheduler.instance)
            .subscribe { movies in
                let isMoviesEmpty = movies.element?.isEmpty ?? true
                self.mainView.noResultImageView.isHidden = !isMoviesEmpty
                self.mainView.noResultLabel.isHidden = !isMoviesEmpty
                self.mainView.collectionView.isHidden = isMoviesEmpty
            }.disposed(by: disposeBag)
        
        mainView.collectionView.rx.modelSelected(MovieDetail.self)
            .observe(on: MainScheduler.instance)
            .subscribe { data in
                let movie = data.element
                showBookmarkAlert(title: "즐겨찾기에 추가하시겠습니까?", subTitle: "제거하시면 복구할 수 없습니다.", buttonTitle: "즐겨찾기 제거", data: movie!, completion: {
                    try! self.repository.localRealm.write({
                        let selectedMovie = self.repository.localRealm.objects(MovieData.self).where {
                            $0.imdbId == movie?.imdbID ?? ""
                        }
                        self.repository.localRealm.delete(selectedMovie)
                        self.input.triggerEvent.onNext(true)
                    })
                })
            }.disposed(by: disposeBag)
        
        func showBookmarkAlert(title: String, subTitle: String, buttonTitle: String, data: MovieDetail, completion: @escaping () -> ()) {
            
            alert.showAlert(title: title, subTitle: subTitle, button: [.cancel, .bookMark])
            alert.bookMarkButton.setTitle(buttonTitle, for: .normal)
            alert.bookMarkButton.backgroundColor = .systemRed
            alert.modalPresentationStyle = .overCurrentContext
            alert.handler = {
                completion()
                self.dismiss(animated: true)
            }
            self.present(alert, animated: false)
        }
        
    }
    
}

extension BookmarkMovieVC: UICollectionViewDelegate {
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        let width = (UIWindow().frame.size.width - 48) / 2
        
        layout.itemSize = CGSize(width: width, height: width * 2 )
        layout.sectionInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        return layout
    }
}

