//
//  iTunesSearchViewController.swift
//  RxSwiftNetworkPractice
//
//  Created by 유철원 on 8/9/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol ITunesSearchViewDelegate {
    func callSearchAPI(keyword: String)
}

final class iTunesSearchViewController: UIViewController {
    
    private let rootView = ITunesSearchView()
    
    private let viewModel = ITunesSearchViewModel()
    
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self
        navigationItem.titleView = rootView.searchBar
        bind()
    }
    
    private func bind() {
        
        let input = ITunesSearchViewModel.Input(searchButtonClicked: rootView.searchBar.rx.searchButtonClicked, searchKeyword: rootView.searchBar.rx.text.orEmpty)
        let output = viewModel.transform(input: input)
        
        output.searchResults
            .bind(to: rootView.tableView.rx.items(cellIdentifier: ITunesSearchTableViewCell.identifier, cellType: ITunesSearchTableViewCell.self)) {
                row, element, cell in
                cell.configureCell(data: element)
            }
            .disposed(by: disposeBag)
        
    }
    
}

extension iTunesSearchViewController: ITunesSearchViewDelegate {
    
    func callSearchAPI(keyword: String) {
    
    }
    
    
}
