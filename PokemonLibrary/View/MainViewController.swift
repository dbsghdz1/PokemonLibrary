//
//  ViewController.swift
//  PokemonLibrary
//
//  Created by 김윤홍 on 8/4/24.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

  let viewModel = MainViewModel()
  var mainView: MainView!
  
  override func loadView() {
    mainView = MainView(frame: UIScreen.main.bounds)
    self.view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setCollectionView()
  }
  
  func setCollectionView() {
    mainView.collectionView.delegate = self
    mainView.collectionView.dataSource = self
    mainView.collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.identifier)
    
  }
}

extension MainViewController: UICollectionViewDelegate {

}

extension MainViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    20
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.identifier, for: indexPath) as? PokemonCell else { return UICollectionViewCell() }

    cell.configureCell(url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(indexPath.row + 1).png")
    return cell
  }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width
    let spacing = 20
    let cellWidth = (Int(width) - spacing) / 3
    return CGSize(width: cellWidth, height: cellWidth)
  }
  
  func collectionView(
      _ collectionView: UICollectionView,
      layout collectionViewLayout: UICollectionViewLayout,
      minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
      return 10.0
    }
  
  func collectionView(
      _ collectionView: UICollectionView,
      layout collectionViewLayout: UICollectionViewLayout,
      minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
      return 10
    }
}

