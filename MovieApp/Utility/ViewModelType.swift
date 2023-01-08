//
//  ViewModelType.swift
//  MovieApp
//
//  Created by 윤여진 on 2022/12/28.
//

import Foundation

protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
    
}
