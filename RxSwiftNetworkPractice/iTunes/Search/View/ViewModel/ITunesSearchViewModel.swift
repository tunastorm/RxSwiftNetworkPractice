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
        let searchResults: PublishSubject<[SoftwareResult]>
    }
    
    func transform(input: Input) -> Output {
        let searchResults = PublishSubject<[SoftwareResult]>()
        
        input.searchButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchKeyword)
            .distinctUntilChanged()
            .map{ ITunesSearchQuery(term: $0) }
            .flatMap { NetworkManager.shared.callITunesSearch($0) }
            .subscribe(with: self) { owner, results in
                searchResults.onNext(results)
            } onError: { owner, error in
                searchResults.onError(error)
            } onCompleted: { _ in
                print("completed")
            } onDisposed: { _ in
                print("disposed")
            }
            .disposed(by: disposeBag)
        
        return Output(searchResults: searchResults)
    }
    
}
