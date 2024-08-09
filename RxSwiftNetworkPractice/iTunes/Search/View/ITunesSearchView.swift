//
//  iTunesSearchView.swift
//  RxSwiftNetworkPractice
//
//  Created by 유철원 on 8/9/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class ITunesSearchView: UIView {
    
    var delegate: ITunesSearchViewDelegate?
    
    let searchBar = UISearchBar()
    
    let tableView = {
        let view = UITableView()
        view.register(ITunesSearchTableViewCell.self, forCellReuseIdentifier: ITunesSearchTableViewCell.identifier)
        view.separatorStyle = .none
        view.rowHeight = 100
        return view
    }()
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        addSubview(searchBar)
        addSubview(tableView)
    }
    
    private func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func configureView() {
        backgroundColor = .white
    }
    
}


