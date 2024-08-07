//
//  DetailView.swift
//  PokemonLibrary
//
//  Created by 김윤홍 on 8/6/24.
//

import UIKit

import SnapKit

class DetailView: UIView {
  
  private lazy var pokemonImage: UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private lazy var pokemonId: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 30)
    return label
  }()
  
  private lazy var pokemonName: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 30)
    return label
  }()
  
  private lazy var pokemonView: UIView = {
    let uiView = UIView()
    uiView.backgroundColor = .darkRed
    return uiView
  }()
  
  private lazy var pokemonType: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 15)
    return label
  }()
  
  private lazy var pokemonHeight: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 15)
    return label
  }()
  
  private lazy var pokemonWeight: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 15)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .mainRed
    configureUI()
    setConstraints()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    self.addSubview(pokemonView)
    [
      pokemonImage,
      pokemonId,
      pokemonName,
      pokemonType,
      pokemonHeight,
      pokemonWeight
    ].forEach { pokemonView.addSubview($0) }
  }
  
  private func setConstraints() {
    pokemonView.snp.makeConstraints { make in
      make.leading.trailing.top.equalTo(self.safeAreaLayoutGuide).inset(30)
      make.bottom.equalTo(self.safeAreaLayoutGuide).inset(300)
    }
    
    pokemonImage.snp.makeConstraints { make in
      make.width.height.equalTo(200)
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().inset(20)
    }
    
    pokemonId.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(60)
      make.top.equalTo(pokemonImage.snp.bottom).offset(10)
    }
    
    pokemonName.snp.makeConstraints { make in
      make.leading.equalTo(pokemonId.snp.trailing).offset(10)
      make.top.equalTo(pokemonImage.snp.bottom).offset(10)
    }
    
    pokemonType.snp.makeConstraints { make in
      make.top.equalTo(pokemonName.snp.bottom).offset(10)
      make.centerX.equalToSuperview()
    }
    
    pokemonHeight.snp.makeConstraints { make in
      make.top.equalTo(pokemonType.snp.bottom).offset(10)
      make.centerX.equalToSuperview()
    }
    
    pokemonWeight.snp.makeConstraints { make in
      make.top.equalTo(pokemonHeight.snp.bottom).offset(10)
      make.centerX.equalToSuperview()
    }
  }
  
  func updateUI(with pokemon: PokemonInfo, id: Int?, image: UIImage?) {
    pokemonImage.image = image
    pokemonId.text = "No. \(id ?? 0)"
    pokemonName.text = "\(PokemonTranslator.getKoreanName(for: pokemon.name))"
    pokemonHeight.text = "키: \(String(pokemon.height)) m"
    pokemonWeight.text = "몸무게: \(String(pokemon.weight)) kg"
    
    let pokemonTypeNames = pokemon.types.map { $0.type.name }
    let pokemonTypeDisplayNames = pokemonTypeNames.compactMap { PokemonTypeName.type(rawValue: $0)?.displayName }
    pokemonType.text = "타입: " + pokemonTypeDisplayNames.joined(separator: ", ")

  }
}
