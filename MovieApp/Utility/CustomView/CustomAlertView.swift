//
//  CustomAlertView.swift
//  MovieApp
//
//  Created by 윤여진 on 2022/12/30.
//

import UIKit

import SnapKit
import Then

enum Button {
    case bookMark
    case cancel
}

final class CustomAlertView: UIViewController {
    
    let mainView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 17)
        $0.adjustsFontSizeToFitWidth = true
        $0.numberOfLines = 0
        $0.backgroundColor = .clear
        $0.textAlignment = .center
    }
    
    let subTitleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 13)
        $0.backgroundColor = .clear
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    let bookMarkButton = UIButton().then {
        $0.setTitle("즐겨찾기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemGreen
        $0.tintColor = .black
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 1
        $0.clipsToBounds = true
    }
    
    let cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .lightGray
        $0.tintColor = .black
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 1
        $0.clipsToBounds = true
    }
    
    let stackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 16
    }
    
    var handler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setConstraints()
        view.backgroundColor = .black.withAlphaComponent(0.6)
        bookMarkButton.addTarget(self, action: #selector(doneButtonClicked(_:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonClicked(_:)), for: .touchUpInside)
        
    }
    
    func showAlert(title: String, subTitle: String, button: [Button]) {
        
        titleLabel.text = title
        subTitleLabel.text = subTitle
        
        for button in button {
            switch button {
            case .bookMark:
                stackView.addArrangedSubview(bookMarkButton)
                bookMarkButton.snp.makeConstraints { make in
                    make.height.equalTo(48)
                }
            case .cancel:
                stackView.addArrangedSubview(cancelButton)
                cancelButton.snp.makeConstraints { make in
                    make.height.equalTo(48)
                }
            }
        }
    }
    
    private func configureUI() {
        
        view.addSubview(mainView)
        
        [titleLabel, subTitleLabel, stackView].forEach {
            mainView.addSubview($0)
        }
        
        
    }
    
    private func setConstraints() {
        
        mainView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width - 60)
            make.height.greaterThanOrEqualTo(156)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.bottom.equalToSuperview().offset(-20)
        }
        
    }
}

//MARK: @objc func Methods
extension CustomAlertView {
    
    @objc func cancelButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func doneButtonClicked(_ sender: UIButton) {
        handler?()
    }
    
}
