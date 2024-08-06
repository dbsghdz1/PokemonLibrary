//
//  DetailViewController.swift
//  PokemonLibrary
//
//  Created by 김윤홍 on 8/5/24.
//

import UIKit

import RxSwift

class DetailViewController: UIViewController {
  
  var receivedImage: UIImage?
  var receivedIndexPath: Int?
  let viewModel = DetailViewModel()
  var detailView = DetailView(frame: .zero)
  private let disposeBag = DisposeBag()
  
  override func loadView() {
    detailView = DetailView(frame: UIScreen.main.bounds)
    self.view = detailView
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
  }
  
  func bind() {
    viewModel.pokemonInfo
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] pokemon in
        guard let pokemon = pokemon else { return }
        self?.detailView.updateUI(with: pokemon, id: self?.receivedIndexPath, image: self?.receivedImage)
      }, onError: { error in
        print(error)
      }).disposed(by: disposeBag)
    viewModel.getPokemonData(url: "https://pokeapi.co/api/v2/pokemon/\(receivedIndexPath ?? 1)/")
  }
}
