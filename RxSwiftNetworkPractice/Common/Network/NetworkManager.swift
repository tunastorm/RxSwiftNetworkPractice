//
//  NetworManager.swift
//  RxSwiftNetworkPractice
//
//  Created by 유철원 on 8/9/24.
//

import Foundation
import RxSwift

final class NetworkManager {
    
    typealias MovieResult = Result<[DailyBoxOffice],BoxOfficeAPIError>
    typealias ITunesResult = Result<[SoftwareResult], APIError>
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func callBoxOffice(date: String) -> Observable<MovieResult> {
        
        let boxOfficeKey = "f7364f38c83c60813feaa0f6ea071c0b"
        
        let url = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=" + boxOfficeKey + "&targetDt=" + date
        
        return Observable<MovieResult>.create { observer in
            guard let url = URL(string: url) else {
                observer.onNext(.failure(.invalidURL))
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error {
                    observer.onNext(.failure(.unknownResponse))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    dump(response)
                    observer.onNext(.failure(.statusError))
                    return
                }
                
                if let data, let appData = try? JSONDecoder().decode(Movie.self, from: data) {
                    observer.onNext(.success(appData.boxOfficeResult.dailyBoxOfficeList))
                } else {
                    print("응답 성공, 디코딩 실패")
                    observer.onNext(.failure(.unknownResponse))
                }
            }.resume()
            
            return Disposables.create()
        }.debug("박스오피스 조회")
    }
    
    func callITunesSearch(_ query: ITunesSearchQuery) -> Single<ITunesResult> {
        let router = APIRouter.search(query)
//        let results = Observable<[SoftwareResult]>.create { observer in
//            APIClient.request(ITunesSearchModel.self, router: router) { model in
//                observer.onNext(model.results)
//                observer.onCompleted()
//            } failure: { error in
//                observer.onError(error)
//            }
//            return Disposables.create()
//        }
        return Single.create { single in
            APIClient.request(ITunesSearchModel.self, router: router) { model in
                single(.success(.success(model.results)))
            } failure: { error in
                single(.success(.failure(error)))
            }
            return Disposables.create()
        }
        .debug("callITunesSearch")
    }
    
}


