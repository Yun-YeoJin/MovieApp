//
//  ReusableProtocol.swift
//  MovieApp
//
//  Created by 윤여진 on 2022/12/27.
//

import UIKit

protocol ReusableProtocol {
    static var reusableIdentifier: String { get }
}

extension UICollectionViewCell: ReusableProtocol {
    
    static var reusableIdentifier: String {
        return String(describing: self)
    }
    
}
