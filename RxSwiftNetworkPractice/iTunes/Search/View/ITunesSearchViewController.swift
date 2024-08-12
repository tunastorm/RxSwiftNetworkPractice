//
//  iTunesSearchViewController.swift
//  RxSwiftNetworkPractice
//
//  Created by 유철원 on 8/9/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ITunesSearchViewController: UIViewController {
    
    private let rootView = ITunesSearchView()
    
    private let viewModel = ITunesSearchViewModel()
    
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = rootView.searchBar
        bind()
    }
    
    private func bind() {
        
        let input = ITunesSearchViewModel.Input(searchButtonClicked: rootView.searchBar.rx.searchButtonClicked, searchKeyword: rootView.searchBar.rx.text.orEmpty)
        
        let output = viewModel.transform(input: input)
    
        output.searchResult
            .map { [weak self] result in
                switch result {
                case .success(let appList): 
                    if appList.count == 0 {
                        self?.rootView.makeToast(APIError.noResultError.message, duration: 3.0, position: .bottom, title: APIError.noResultError.title)
                    }
                    return appList
                case .failure(let error):
                    self?.rootView.makeToast(error.message, duration: 3.0, position: .bottom, title: error.title)
                    return []
                }
            }
            .debug("searchResults Bind")
            .drive(rootView.tableView.rx.items(cellIdentifier: ITunesSearchTableViewCell.identifier, cellType: ITunesSearchTableViewCell.self)) {
                row, element, cell in
                cell.configureCell(data: element)
            }
            .disposed(by: disposeBag)
        
        rootView.tableView.rx.modelSelected(SoftwareResult.self)
            .bind(with: self) { owner, data in
                let vc = ITunesDetailViewController()
                vc.viewModel.data = data
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
}
