//
//  DetailViewModel.swift
//  PokemonLibrary
//
//  Created by 김윤홍 on 8/5/24.
//

import UIKit

import RxSwift
import RxCocoa

class DetailViewModel {
  
  private let pokemonId: Int
  
  init(pokemonId: Int) {
    self.pokemonId = pokemonId
  }
  
  private let pokemonInfoRelay = BehaviorRelay<PokemonInfo?>(value: nil)
  var pokemonInfo: Driver<PokemonInfo?> {
    return pokemonInfoRelay.asDriver()
  }

  private let disposeBag = DisposeBag()
  
  func getPokemonData() {
    guard let pokemonUrl = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonId)/") else {
      return
    }
    
    NetworkManager.shared.dataFetch(url: pokemonUrl)
      .subscribe(onSuccess: { [weak self] (pokemon: PokemonInfo) in
        self?.pokemonInfoRelay.accept(pokemon)
      }).disposed(by: disposeBag)
  }
}
