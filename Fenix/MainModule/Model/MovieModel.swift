//
//  MovieModel.swift
//  Fenix
//
//  Created by ayaz akbar on 18/03/2022.
//


import Foundation
import UIKit

struct Movie: Decodable {
    var results: [ResultPart]
}

struct ResultPart: Decodable {
    
    var isFavouriteMovie: Bool = false
    let title: String?
    let vote_average: Double?
    let id: Int?
    let overview: String?
    let release_date: String?
    let poster_path: String?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case vote_average
        case id
        case overview
        case release_date
        case poster_path
    }
    

}

struct Constants {
    static let leftDistanceToView: CGFloat = 20
    static let rightDistanceToView: CGFloat = 20
    static let galleryMinimumLineSpacing: CGFloat = 10
    static let galleryItemWidth = (UIScreen.main.bounds.width - Constants.leftDistanceToView - Constants.rightDistanceToView)
}

