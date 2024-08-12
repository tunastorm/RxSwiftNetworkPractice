//
//  iTunesSearchViewModel.swift
//  RxSwiftNetworkPractice
//
//  Created by 유철원 on 8/9/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ITunesSearchViewModel: BaseViewModel {

    private var disposeBag = DisposeBag()
    
    struct Input {
        let searchButtonClicked: ControlEvent<Void>
        let searchKeyword: ControlProperty<String>
    }
    
    struct Output {
        let searchResult: Driver<Result<[SoftwareResult], APIError>>
    }
    
    func transform(input: Input) -> Output {
        
        let searchResult = input.searchButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchKeyword)
            .distinctUntilChanged()
            .map{ ITunesSearchQuery(term: $0) }
            .flatMap { NetworkManager.shared.callITunesSearch($0) }
            .asDriver(onErrorJustReturn: .failure(.unExpectedError))
            .debug("searchButtronClicked")
    
        return Output(searchResult: searchResult)
    }
    
}
