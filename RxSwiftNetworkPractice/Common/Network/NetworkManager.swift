//
//  NetworManager.swift
//  RxSwiftNetworkPractice
//
//  Created by 유철원 on 8/9/24.
//

import Foundation
import RxSwift

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func callBoxOffice(date: String) -> Observable<Movie> {
        
        let boxOfficeKey = "f7364f38c83c60813feaa0f6ea071c0b"
        
        let url = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=" + boxOfficeKey + "&targetDt=" + date
        
        let result = Observable<Movie>.create { observer in
            guard let url = URL(string: url) else {
                observer.onError(BoxOfficeAPIError.invalidURL)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error {
                    observer.onError(BoxOfficeAPIError.unknownResponse)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    dump(response)
                    observer.onError(BoxOfficeAPIError.statusError)
                    return
                }
                
                if let data, let appData = try? JSONDecoder().decode(Movie.self, from: data) {
                    observer.onNext(appData)
                    observer.onCompleted()
                } else {
                    print("응답 성공, 디코딩 실패")
                    observer.onError(BoxOfficeAPIError.unknownResponse)
                }
            }.resume()
            
            return Disposables.create()
        }.debug("박스오피스 조회")
        
        
        return result
    }
    
    func callITunesSearch(_ query: ITunesSearchQuery) -> Observable<[SoftwareResult]> {
        let router = APIRouter.search(query)
        let results = Observable<[SoftwareResult]>.create { observer in
            APIClient.request(ITunesSearchModel.self, router: router) { model in
                observer.onNext(model.results)
                observer.onCompleted()
            } failure: { error in
                observer.onError(error)
            }
            return Disposables.create()
        }
        return results
    }
    
}


