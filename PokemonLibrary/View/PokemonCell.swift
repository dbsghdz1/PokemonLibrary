//
//  PokemonCell.swift
//  PokemonLibrary
//
//  Created by 김윤홍 on 8/5/24.
//

import UIKit

import Kingfisher
import SnapKit

class PokemonCell: UICollectionViewCell {
  static let identifier = "pokemonCell"
  
  lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(imageView)
    
    imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    self.backgroundColor = .cellBackground
    self.layer.cornerRadius = 10
  }
  
  override func prepareForReuse() {
     super.prepareForReuse()
    imageView.image = nil
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureCell(id: Int) {
    let url = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
    guard let imageUrl = URL(string: url) else { return }
    imageView.kf.setImage(with: imageUrl)
  }
}
