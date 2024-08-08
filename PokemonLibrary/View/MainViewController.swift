//
//  ViewController.swift
//  PokemonLibrary
//
//  Created by 김윤홍 on 8/4/24.
//

import UIKit

import RxCocoa
import RxSwift

class MainViewController: UIViewController {
  
  private let viewModel = MainViewModel()
  var moveNextPage: ((UIImage?, Int) -> Void)?
  private var mainView = MainView(frame: .zero)
  private let disposeBag = DisposeBag()
  
  override func loadView() {
    mainView = MainView(frame: UIScreen.main.bounds)
    self.view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setCollectionView()
    bind()
  }
  
  private func setCollectionView() {
    mainView.collectionView.delegate = self
    mainView.collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.identifier)
  }
  
  private func bind() {
    let isScrolled = mainView.collectionView.rx.didScroll
      .flatMapLatest { [weak self] _ -> Observable<Void> in
        guard let self = self else { return .empty() }
        let currentY = self.mainView.collectionView.contentOffset.y
        let cellHeight = self.mainView.collectionView.contentSize.height
        let collectionViewHeight = self.mainView.collectionView.frame.size.height
        if currentY > cellHeight - collectionViewHeight - 100 {
          return Observable.just(())
        } else {
          return Observable.empty()
        }
      }
    
    let input = MainViewModel.Input(isScrolled: isScrolled)
    let output = viewModel.transform(input: input)
    
    output.pokemonIds
      .debug()
      .drive(mainView.collectionView.rx.items(cellIdentifier: PokemonCell.identifier, cellType: PokemonCell.self)) { _, id, cell in
        cell.configureCell(id: id)
      }.disposed(by: disposeBag)
    
    mainView.collectionView.rx.itemSelected
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { indexPath in
        if let cell = self.mainView.collectionView.cellForItem(at: indexPath) as? PokemonCell {
          let currentIds = self.viewModel.ids.value
          let selectedId = currentIds[indexPath.row]
          self.moveNextPage?(cell.imageView.image, selectedId)
        }
      }).disposed(by: disposeBag)
  }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width
    let cellWidth = (Int(width) - 20) / 3
    return CGSize(width: cellWidth, height: cellWidth)
  }
}

