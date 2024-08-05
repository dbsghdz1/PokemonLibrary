//
//  MainViewModel.swift
//  PokemonLibrary
//
//  Created by 김윤홍 on 8/4/24.
//
// Observavle의 생명주기
// create -> Subscribe(실행) -> onNext -> onCompleted or Error -> Disposed .debug() 활용

import UIKit
import RxSwift

class MainViewModel {
  
  func getPokemonUrl() -> Single<[String]> {
    guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0") else {
      return Single.error(NetworkError.invalidUrl)
    }
    
    return NetworkManager.shared.dataFetch(url: url)
      .flatMap { (response: PokemonData) -> Single<[String]> in
        let pokemonUrl = response.results.compactMap { $0.url }
        return Single.just(pokemonUrl)
      }
  }
}
