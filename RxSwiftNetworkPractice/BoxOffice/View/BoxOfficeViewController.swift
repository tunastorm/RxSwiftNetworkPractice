//
//  BoxOfficeViewController.swift
//  RxSwiftNetworkPractice
//
//  Created by 유철원 on 8/9/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Toast

class BoxOfficeViewController: UIViewController {
    
    private let tableView = UITableView()
    
    private let layout = {
       let layout = UICollectionViewFlowLayout()
       layout.itemSize = CGSize(width: 120, height: 40)
       layout.scrollDirection = .horizontal
       return layout
   }

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let searchBar = UISearchBar()
    
    private var disposeBag = DisposeBag()
    
    private let viewModel = BoxOfficeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
        bind()
    }
    
    private func configureHierarchy() {
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        navigationItem.titleView = searchBar
    }
    
    private func configureLayout() {
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }

    private func configureView() {
        view.backgroundColor = .white
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.backgroundColor = .lightGray
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.backgroundColor = .systemGreen
        tableView.rowHeight = 100
    }
    
    private func bind() {
        
        let recentText = PublishSubject<String>()
        
        let input = BoxOfficeViewModel.Input(searchButtonTap: searchBar.rx.searchButtonClicked, searchText: searchBar.rx.text.orEmpty, recentText: recentText)
        
        Observable.zip(tableView.rx.modelSelected(DailyBoxOffice.self), tableView.rx.itemSelected)
            .map{ "검색어는 \($0.0.movieNm)" }
            .debug("박스오피스 클릭됨")
            .subscribe(with: self) { owner, value in
                input.recentText.onNext(value)
            }
            .disposed(by: disposeBag)
        
        let output = viewModel.transform(input: input)
        
        output.recentList
            .bind(to:collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.identifier, cellType: MovieCollectionViewCell.self)) {
                row, element, cell in
                cell.configureCell(data: "\(row), \(element)")
            }
            .disposed(by: disposeBag)
        
        output.boxOfficeList
            .bind(to: tableView.rx.items(cellIdentifier: MovieTableViewCell.identifier, cellType: MovieTableViewCell.self)) {
                row, element, cell in
                cell.configureCell(data: element)
            }
            .disposed(by: disposeBag)
        
        output.error
            .bind(with: self) { owner, error in
                owner.view.makeToast(error.localizedDescription, duration: 3.0, position: .bottom)
            }
            .disposed(by: disposeBag)
    }
}
