//
//  SearchMovieView.swift
//  MovieApp
//
//  Created by 윤여진 on 2022/12/27.
//

import UIKit
import SnapKit
import Then

final class SearchMovieView: BaseView {
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.reusableIdentifier)
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()
    
    let searchBar = UISearchBar().then {
        $0.backgroundColor = .white
        $0.placeholder = "영화를 검색해보세요."
    }
    
    let noResultImageView = UIImageView().then {
        $0.isHidden = false
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "noResult")
    }
    
    let noResultLabel = UILabel().then {
        $0.isHidden = false
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textAlignment = .center
        $0.textColor = .systemGreen
        $0.text = "검색 결과가 없습니다."
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func configureUI() {
        super.configureUI()
        [collectionView, noResultImageView, noResultLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        noResultImageView.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.centerY.equalToSuperview().offset(-50)
            make.centerX.equalToSuperview()
        }
        
        noResultLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(noResultImageView.snp.bottom).offset(16)
        }
        
    }
    
}
