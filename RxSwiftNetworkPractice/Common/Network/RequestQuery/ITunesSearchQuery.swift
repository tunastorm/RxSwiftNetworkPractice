//
//  iTunesSearchQuery.swift
//  RxSwiftNetworkPractice
//
//  Created by 유철원 on 8/9/24.
//

import Foundation


struct ITunesSearchQuery: Encodable {
    let term: String
    let country = "KR"
    let media = "software"
    let entity = "software"
}


