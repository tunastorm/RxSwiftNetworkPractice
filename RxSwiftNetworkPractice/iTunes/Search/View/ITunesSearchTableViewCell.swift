//
//  iTunesSearchTableViewCell.swift
//  RxSwiftNetworkPractice
//
//  Created by 유철원 on 8/9/24.
//

import UIKit
import Kingfisher

final class ITunesSearchTableViewCell: UITableViewCell {
    
    private let titleView = UIView()
    
    private let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("받기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.isUserInteractionEnabled = true
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let starImageView = UIImageView().then {
        $0.image = UIImage(systemName: "star.fill")
        $0.contentMode = .scaleAspectFit
    }
    
    private let averageRateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 10)
        $0.textColor = .lightGray
    }
    
    private let sellerNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 10)
        $0.textColor = .lightGray
        $0.textAlignment = .center
    }
    
    private let genreLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 10)
        $0.textColor = .lightGray
        $0.textAlignment = .right
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        contentView.addSubview(titleView)
        titleView.addSubview(appNameLabel)
        titleView.addSubview(appIconImageView)
        titleView.addSubview(downloadButton)
        contentView.addSubview(starImageView)
        contentView.addSubview(averageRateLabel)
        contentView.addSubview(sellerNameLabel)
        contentView.addSubview(genreLabel)
    }
    
    private func configureLayout() {
        titleView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(72)
        }
        
        appIconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(20)
            $0.size.equalTo(60)
        }
        
        appNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(appIconImageView)
            $0.leading.equalTo(appIconImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(downloadButton.snp.leading).offset(-8)
        }
        
        downloadButton.snp.makeConstraints {
            $0.centerY.equalTo(appIconImageView)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(32)
            $0.width.equalTo(72)
        }
        
        starImageView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(4)
            make.bottom.equalToSuperview().inset(4)
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(20)
        }
        averageRateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(4)
            make.bottom.equalToSuperview().inset(4)
            make.leading.equalTo(starImageView.snp.trailing).offset(4)
            make.height.equalTo(20)
            make.width.equalTo(50)
        }
        sellerNameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(4)
            make.bottom.equalToSuperview().inset(4)
            make.leading.equalTo(averageRateLabel.snp.trailing).offset(4)
            make.height.equalTo(20)
        }
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(4)
            make.bottom.equalToSuperview().inset(4)
            make.leading.equalTo(sellerNameLabel.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(20)
            make.width.equalTo(60)
        }
    }
    
    func configureCell(data: SoftwareResult) {
        appNameLabel.text = data.trackName
        if let url = URL(string: data.artworkUrl100) {
            appIconImageView.kf.setImage(with: url)
        }
        averageRateLabel.text = String(format: "%.1f", data.averageUserRating)
        sellerNameLabel.text = data.sellerName
        genreLabel.text = data.genres.first
    }
    
}
