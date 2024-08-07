//
//  ViewController.swift
//  PokemonLibrary
//
//  Created by 김윤홍 on 8/4/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class MainViewController: UIViewController {
  
  let viewModel = MainViewModel()
  var moveNextPage: ((UIImage?, Int) -> Void)?
  var mainView = MainView(frame: .zero)
  var idArray = [Int]()
  let disposeBag = DisposeBag()
  var check = true
  
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
    mainView.collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.identifier)
  }
  
  func bind() {
    
    viewModel.ids
      .bind(to: mainView.collectionView.rx
        .items(cellIdentifier: PokemonCell.identifier, cellType: PokemonCell.self)) { index, id, cell in
          cell.configureCell(id: id)
        }.disposed(by: disposeBag)
    
    mainView.collectionView.rx.itemSelected
      .subscribe(onNext: { indexPath in
        if let cell = self.mainView.collectionView.cellForItem(at: indexPath) as? PokemonCell {
          do {
            let currentIds = try self.viewModel.ids.value()
            let selectedId = currentIds[indexPath.row]
            self.moveNextPage?(cell.imageView.image, selectedId)
          } catch {
            print("Error retrieving current value: \(error)")
          }
        }
      }).disposed(by: disposeBag)
    
    mainView.collectionView.rx.didScroll
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        let currentY = self.mainView.collectionView.contentOffset.y
        let cellHeight = self.mainView.collectionView.contentSize.height
        let collectionViewHeight = self.mainView.collectionView.frame.size.height
        if currentY > cellHeight - collectionViewHeight - 100 {
          viewModel.getNextPokemon(pokemonUrl: self.viewModel.apiUrl)
        }
      }).disposed(by: disposeBag)
  }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width
    let spacing = 20
    let cellWidth = (Int(width) - spacing) / 3
    return CGSize(width: cellWidth, height: cellWidth)
  }
}

