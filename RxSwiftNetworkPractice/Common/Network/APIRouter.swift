//
//  APIRouter.swift
//  RxSwiftNetworkPractice
//
//  Created by 유철원 on 8/9/24.
//

import Foundation
import Alamofire

enum APIRouter: TargetType {

    case search(_ query: ITunesSearchQuery)
    
    // 열거형 asoociate value
    var baseURL: String {
        return APIConstant.iTuens.baseURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }

    var path: String {
        return switch self {
        case .search: "/search"
        }
    }
    
    var parameters: Encodable? {
        return switch self {
        case .search(let query): query
        }
    }
    
    var encoder: ParameterEncoder {
        switch self {
        case .search:
            return URLEncodedFormParameterEncoder.default
        }
    }
}


