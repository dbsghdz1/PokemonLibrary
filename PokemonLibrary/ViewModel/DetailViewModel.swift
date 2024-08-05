//
//  DetailViewModel.swift
//  PokemonLibrary
//
//  Created by 김윤홍 on 8/5/24.
//

import Foundation
import RxSwift

class DetailViewModel {
  
  let pokemonInfo = BehaviorSubject<PokemonInfo?>(value: nil)
  private let disposeBag = DisposeBag()
  
  func getPokemonData(url: String) {
    guard let pokemonUrl = URL(string: url) else {
      pokemonInfo.onError(NetworkError.invalidUrl)
      return
    }
    
    NetworkManager.shared.dataFetch(url: pokemonUrl)
      .subscribe(onSuccess: { [weak self] (pokemon: PokemonInfo) in
        self?.pokemonInfo.onNext(pokemon)
      }, onFailure: { [weak self] error in
        self?.pokemonInfo.onError(error)
      }).disposed(by: disposeBag)
  }
}
