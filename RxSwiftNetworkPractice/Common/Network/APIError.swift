//
//  APIError.swift
//  RxSwiftNetworkPractice
//
//  Created by 유철원 on 8/9/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
}
