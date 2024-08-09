//
//  ITunesSearchDetailViewController.swift
//  RxSwiftNetworkPractice
//
//  Created by 유철원 on 8/9/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ITunesDetailViewController: UIViewController {
    
    private let rootView = ITunesDetailView()
    
    let viewModel = ITunesDetailViewModel()
    
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        let input = ITunesDetailViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.appData
            .bind(with: self) { owner, result in
                guard let result else { return }
                owner.rootView.fetchData(data: result)
            }
            .disposed(by: disposeBag)
    }
    
}
