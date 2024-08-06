//
//  ViewController.swift
//  PokemonLibrary
//
//  Created by 김윤홍 on 8/4/24.
//

import UIKit

import RxSwift
import SnapKit

class MainViewController: UIViewController {
  
  let viewModel = MainViewModel()
  var moveNextPage: ((UIImage?, Int) -> Void)?
  var mainView = MainView(frame: .zero)
  var ids = [Int]()
  let disposeBag = DisposeBag()
  
  override func loadView() {
    mainView = MainView(frame: UIScreen.main.bounds)
    self.view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setCollectionView()
    bind()
  }
  
  func setCollectionView() {
    mainView.collectionView.delegate = self
    mainView.collectionView.dataSource = self
    mainView.collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.identifier)
  }
  
  func bind() {
    viewModel.getPokemonUrl()
      .observe(on: MainScheduler.instance)
      .subscribe(onSuccess: { [weak self] urls in
        self?.ids = urls.compactMap { url in
          self?.extractID(from: url)
        }
        self?.mainView.collectionView.reloadData()
      }, onFailure: { error in
        print(error)
      })
      .disposed(by: disposeBag)
  }
  
  func extractID(from url: String) -> Int? {
    guard let lastComponent = url.split(separator: "/").last else {
      return nil
    }
    return Int(lastComponent)
  }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    ids.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.identifier, for: indexPath) as? PokemonCell else { return UICollectionViewCell() }
    
    let id = ids[indexPath.row]
    cell.configureCell(id: id)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let cell = collectionView.cellForItem(at: indexPath) as? PokemonCell {
      moveNextPage?(cell.imageView.image, ids[indexPath.row])
    }
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

