//
//  iTunesSearchModel.swift
//  RxSwiftNetworkPractice
//
//  Created by 유철원 on 8/9/24.
//

import Foundation


struct ITunesSearchModel: Decodable {
    let resultCount: Int
    let results: [SoftwareResult]
}

struct SoftwareResult: Decodable {
    let trackName: String
    let sellerName: String
    let releaseDate: String
    let averageUserRating: Double
    let genres: [String]
    let version: String
    let description: String
    let artworkUrl100: String
    let artworkUrl512: String
}
