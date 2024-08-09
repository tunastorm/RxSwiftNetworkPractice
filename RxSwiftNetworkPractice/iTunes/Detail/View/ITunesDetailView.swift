//
//  ITunesDetailView.swift
//  RxSwiftNetworkPractice
//
//  Created by 유철원 on 8/9/24.
//

import UIKit
import Kingfisher
import SnapKit
import Then

final class ITunesDetailView: UIView {
    
    let viewModel = ITunesDetailViewModel()
    
    let appImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 14
    }
    
    let appNameLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textAlignment = .left
    }
    
    let sellerNameLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 12)
        $0.textAlignment = .left
        $0.textColor = .lightGray
    }
    
    let downloadButton = UIButton().then {
        $0.configuration = .filled()
        $0.configuration?.title = "받기"
        $0.configuration?.cornerStyle = .capsule
        $0.configuration?.baseBackgroundColor = .systemBlue
        $0.configuration?.baseForegroundColor = .white
    }
    
    private let newsLabel = UILabel().then {
        $0.text = "새로운 소식"
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textAlignment = .left
    }
    
    private let versionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .lightGray
        $0.textAlignment = .left
    }
    
    private let descriptionTextView = UITextView().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textAlignment = .natural
    }
    
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
        addSubview(appImageView)
        addSubview(appNameLabel)
        addSubview(sellerNameLabel)
        addSubview(downloadButton)
        addSubview(newsLabel)
        addSubview(versionLabel)
        addSubview(descriptionTextView)
    }
    
    private func configureLayout() {
        
        appImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(safeAreaLayoutGuide).inset(20)
            make.size.equalTo(120)
        }
        sellerNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(appImageView)
            make.height.equalTo(20)
            make.leading.equalTo(appImageView.snp.trailing).offset(20)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        appNameLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.bottom.equalTo(sellerNameLabel.snp.top).offset(-10)
            make.leading.equalTo(appImageView.snp.trailing).offset(20)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        downloadButton.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.width.equalTo(80)
            make.top.equalTo(sellerNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(appImageView.snp.trailing).offset(20)
        }
        newsLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(120)
            make.top.equalTo(appImageView.snp.bottom).offset(30)
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
        }
        versionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(100)
            make.top.equalTo(newsLabel.snp.bottom).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
        }
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(versionLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
    }
    
    private func configureView() {
        backgroundColor = .white
    }
    
    func fetchData(data: SoftwareResult) {
        if let url = URL(string: data.artworkUrl512) {
            appImageView.kf.setImage(with: url)
        }
        appNameLabel.text = data.trackName
        sellerNameLabel.text = data.sellerName
        versionLabel.text = "버전 " + data.version
        descriptionTextView.text = data.description
    }
    

}
