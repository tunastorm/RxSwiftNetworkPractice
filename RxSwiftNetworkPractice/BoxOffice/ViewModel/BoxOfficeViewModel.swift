//
//  BoxOfficeViewModel.swift
//  RxSwiftNetworkPractice
//
//  Created by 유철원 on 8/9/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BoxOfficeViewModel: BaseViewModel {
    
    private var dispsoeBag = DisposeBag()
    private var recentList = ["a", "b"]
    
    struct Input {
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
        let recentText: PublishSubject<String>
    }
    
    struct Output {
        let boxOfficeList: Driver<Result<[DailyBoxOffice], BoxOfficeAPIError>>
        let recentList: BehaviorSubject<[String]>
    }
    
    func transform(input: Input) -> Output {
        
        let recentList = BehaviorSubject(value: recentList)

        input.recentText
            .subscribe(with: self) { owner, value in
                owner.recentList.append(value)
                recentList.onNext(owner.recentList)
            }
            .disposed(by: dispsoeBag)
        
        let boxOfficeList = input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .debug("검색어 입력")
            .distinctUntilChanged()
            .map { value in
                guard let intText = Int(value) else {
                    return 20000101
                }
                return intText
            }
            .map { String($0) }
            .flatMap{ NetworkManager.shared.callBoxOffice(date: $0) }
            .asDriver(onErrorJustReturn: .failure(.unexpectedError))
            .debug("searchButtonTap")

        input.searchText
            .subscribe(with: self) { owner, value in
                print("뷰모델 글자 인식")
            }.disposed(by: dispsoeBag)
        
        return Output(boxOfficeList: boxOfficeList, recentList: recentList)
    }
    
}

