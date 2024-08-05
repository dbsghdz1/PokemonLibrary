//
//  View.swift
//  PokemonLibrary
//
//  Created by 김윤홍 on 8/5/24.
//

import UIKit

class MainView: UIView {
  
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    imageView.image = UIImage(named: "pokemonBall")
    return imageView
  }()
  
  lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.backgroundColor = .darkRed
    return collectionView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .mainRed
    configureUI()
    setConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    [imageView, collectionView].forEach { self.addSubview($0) }
  }
  
  private func setConstraints() {
    imageView.snp.makeConstraints { make in
      make.width.height.equalTo(100)
      make.centerX.equalToSuperview()
      make.top.equalTo(self.safeAreaLayoutGuide)
    }
    
    collectionView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.bottom.equalTo(self.safeAreaLayoutGuide)
      make.top.equalTo(imageView.snp.bottom).offset(10)
    }
  }
}

extension UIColor {
  static let mainRed = UIColor(red: 190/255, green: 30/255, blue: 40/255, alpha: 1.0)
  static let darkRed = UIColor(red: 120/255, green: 30/255, blue: 30/255, alpha: 1.0)
  static let cellBackground = UIColor(red: 245/255, green: 245/255, blue: 235/255, alpha: 1.0)
}
