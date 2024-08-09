//
//  MovieCollectionViewCell.swift
//  RxSwiftNetworkPractice
//
//  Created by 유철원 on 8/9/24.
//

import UIKit
import SnapKit
import Then

final class MovieCollectionViewCell: UICollectionViewCell {
    
    private var label = UILabel().then {     
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 13)
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
        contentView.addSubview(label)
    }
    
    private func configureLayout() {
        label.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    private func configureView() {
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
    
    func configureCell(data: String) {
        label.text = data
    }
    
}


