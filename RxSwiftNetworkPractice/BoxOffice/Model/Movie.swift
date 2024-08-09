//
//  Movie.swift
//  RxSwiftNetworkPractice
//
//  Created by 유철원 on 8/9/24.
//

import Foundation

struct Movie: Decodable {
    
    let boxOfficeResult: BoxOfficeResult
    
}

struct BoxOfficeResult: Decodable {
    
    let dailyBoxOfficeList: [DailyBoxOffice]
    
}

struct DailyBoxOffice: Decodable {
    
    let movieNm: String
    let openDt: String
    
}
