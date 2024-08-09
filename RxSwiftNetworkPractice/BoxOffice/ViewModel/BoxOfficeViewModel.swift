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
        let boxOfficeList: PublishSubject<[DailyBoxOffice]>
        let recentList: BehaviorSubject<[String]>
        let error: PublishSubject<Error>
    }
    
    func transform(input: Input) -> Output {
        
        let recentList = BehaviorSubject(value: recentList)
        let boxOfficeList = PublishSubject<[DailyBoxOffice]>()
        let errorResult = PublishSubject<Error>()
        
        input.recentText
            .subscribe(with: self) { owner, value in
                owner.recentList.append(value)
                recentList.onNext(owner.recentList)
            }
            .disposed(by: dispsoeBag)
        
        input.searchButtonTap
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
            .debug()
            .subscribe(with: self) { owner, value in
                boxOfficeList.onNext(value.boxOfficeResult.dailyBoxOfficeList)
            } onError: { owner, error in
                errorResult.onNext(error)
            } onCompleted: { _ in
                print("completed")
            } onDisposed: { _ in
                print("disposed")
            }
            .disposed(by: dispsoeBag)

        input.searchText
            .subscribe(with: self) { owner, value in
                print("뷰모델 글자 인식")
            }.disposed(by: dispsoeBag)
        
        return Output(boxOfficeList: boxOfficeList, recentList: recentList, error: errorResult)
    }
    
}

