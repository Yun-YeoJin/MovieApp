//
//  MovieCollectionViewCell.swift
//  MovieApp
//
//  Created by 윤여진 on 2022/12/27.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RealmSwift

final class MovieCollectionViewCell: BaseCollectionViewCell {
    
    var onData = PublishSubject<MovieDetail>()
    
    private var tasks: Results<MovieData>!
    
    private var isBookmarkedMovies: Results<MovieData>!
    
    private let repository = MovieRepository()
    
    private var cellDisposeBag = DisposeBag()
    
    private var id = ""
    
    let moviePosterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    let movieTitleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = .boldSystemFont(ofSize: 15)
    }
    
    let movieYearLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 13)
    }
    
    let movieTypeLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 13)
    }
    
    let isBookmarkedButton = UIButton().then {
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .white
        $0.setImage(UIImage(named: "bookmark"), for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.isBookmarkedButton.setImage(UIImage(named: "bookmark"), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
        onData.observe(on: MainScheduler.instance)
            .subscribe { [weak self] in
                self?.movieTitleLabel.text = $0.element?.title
                self?.movieYearLabel.text = $0.element?.year
                self?.movieTypeLabel.text = $0.element?.type
                let url = URL(string: $0.element!.poster)
                self?.moviePosterImageView.kf.setImage(with: url)
                self?.id = $0.element?.imdbID ?? ""
                
                // 북마크 된 무비의 목록
                self?.tasks = self?.repository.localRealm.objects(MovieData.self)
                self?.isBookmarkedMovies = self?.tasks.where {
                    $0.isBookmarked == true
                }
                let movie = self?.isBookmarkedMovies.filter{ movieData in
                    movieData.imdbId == self?.id
                }.first
                if movie?.isBookmarked == true {
                    self?.isBookmarkedButton.setImage(UIImage(named: "bookmark.fill"), for: .normal)
                }
            }.disposed(by: cellDisposeBag)
        
    }
    
    override func configureUI() {
        super.configureUI()
        [moviePosterImageView, isBookmarkedButton, movieTitleLabel, movieYearLabel, movieTypeLabel].forEach {
            self.addSubview($0)
        }
        self.layer.cornerRadius = 8
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    override func setConstraints() {
        
        moviePosterImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        isBookmarkedButton.snp.makeConstraints { make in
            make.top.equalTo(moviePosterImageView.snp.top).offset(16)
            make.trailing.equalTo(moviePosterImageView.snp.trailing).inset(12)
            make.size.equalTo(40)
        }
        
        movieTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(moviePosterImageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        movieYearLabel.snp.makeConstraints { make in
            make.top.equalTo(movieTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        movieTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(movieYearLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
        
    }
    
}
