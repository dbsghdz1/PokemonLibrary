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
  private var viewModel: DetailViewModel!
  private var detailView = DetailView(frame: .zero)
  private let disposeBag = DisposeBag()
  
  override func loadView() {
    detailView = DetailView(frame: UIScreen.main.bounds)
    self.view = detailView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let pokemonId = receivedIndexPath else { return }
    viewModel = DetailViewModel(pokemonId: pokemonId)
    viewModel.getPokemonData()
    bind()
  }
  
  private func bind() {
    viewModel.pokemonInfo
      .drive(onNext: { [weak self] pokemon in
        guard let pokemon = pokemon else { return }
        self?.detailView.updateUI(with: pokemon, id: self?.receivedIndexPath, image: self?.receivedImage)
      }).disposed(by: disposeBag)
  }
}
