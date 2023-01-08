//
//  SearchMovieVC.swift
//  MovieApp
//
//  Created by 윤여진 on 2022/12/27.
//

import UIKit

import Kingfisher
import JGProgressHUD
import RxCocoa
import RxSwift
import RxDataSources

final class SearchMovieVC: BaseViewController {
    
    private let mainView = SearchMovieView()
    private let viewModel = SearchViewModel()
    private let alert = CustomAlertView()
    private let hud = JGProgressHUD()
    private var disposeBag = DisposeBag()
    
    private var page: Int = 0
    
    override func loadView() {
        self.view = mainView
    }
    
    private var dataSources = RxCollectionViewSectionedReloadDataSource<MovieSectionModel>(configureCell: { dataSource, collectionView, indexPath, item in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reusableIdentifier, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        cell.onData.onNext(item)
        return cell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNav()
        setGesture()
        mainView.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        mainView.collectionView.collectionViewLayout = collectionViewLayout()
        mainView.collectionView.delegate = self
        bindRX()
        
    }
    
    private func configureNav() {
        self.navigationItem.titleView = mainView.searchBar
    }
    
}

extension SearchMovieVC {
    
    private func bindRX() {
        
        let input = SearchViewModel.Input(viewDidLoadEvent: Observable.just(()), titleSubject: PublishSubject<String>(), pageSubject: PublishSubject<Int>(), searchButtonTap: mainView.searchBar.rx.searchButtonClicked, bookmarkItem: PublishSubject<MovieDetail>())
        
        let output = viewModel.transform(input: input)
        
        input.searchButtonTap
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.hud.show(in: self.mainView)
                input.titleSubject.onNext(self.mainView.searchBar.text ?? "")
                self.page = 1
                input.pageSubject.onNext(self.page)
                vc.mainView.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                vc.hud.dismiss(animated: true)
                vc.mainView.searchBar.endEditing(true)
            }).disposed(by: disposeBag)
        
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
        
        mainView.collectionView.rx.didScroll
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { vc, _ in
                if vc.mainView.collectionView.contentOffset.y == (self.mainView.collectionView.contentSize.height - self.mainView.collectionView.bounds.size.height) {
                    self.page += 1
                    input.pageSubject.onNext(self.page)
                }
            }.disposed(by: disposeBag)
    
        mainView.collectionView.rx.modelSelected(MovieDetail.self)
            .observe(on: MainScheduler.instance)
            .subscribe { data in
                let movie = data.element
                showBookmarkAlert(title: "즐겨찾기에 추가하시겠습니까?", subTitle: "추가하시면 따로 모아볼 수 있습니다.", buttonTitle: "즐겨찾기", data: movie!) {
                    input.bookmarkItem.onNext(movie!)
                }
            }.disposed(by: disposeBag)
        
        func showBookmarkAlert(title: String, subTitle: String, buttonTitle: String, data: MovieDetail, completion: @escaping () -> ()) {
            
            alert.showAlert(title: title, subTitle: subTitle, button: [.cancel, .bookMark])
            alert.bookMarkButton.setTitle(buttonTitle, for: .normal)
            alert.modalPresentationStyle = .overCurrentContext
            alert.handler = {
                completion()
                self.dismiss(animated: true)
            }
            self.present(alert, animated: false)
        }
    }
}

extension SearchMovieVC: UICollectionViewDelegate, UIScrollViewDelegate {
    
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

extension SearchMovieVC {
    
    private func setGesture() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        self.mainView.addGestureRecognizer(swipeUp)
        
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.up:
                mainView.searchBar.endEditing(true)
            default:
                break
            }
        }
    }
    
}

