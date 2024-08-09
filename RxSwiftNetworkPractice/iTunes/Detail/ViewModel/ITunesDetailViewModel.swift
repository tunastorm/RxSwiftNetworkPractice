//
//  ITunesDetailViewModel.swift
//  RxSwiftNetworkPractice
//
//  Created by 유철원 on 8/9/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ITunesDetailViewModel: BaseViewModel {
    
    var data: SoftwareResult?
    
    struct Input {
        
    }
    
    struct Output {
        let appData: BehaviorSubject<SoftwareResult?>
    }
    
    func transform(input: Input) -> Output {
        let appData = BehaviorSubject(value: data)
        
        return Output(appData: appData)
    }
    
}
