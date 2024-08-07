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
  
  init() {
    getPokemonId(pokemonUrl: apiUrl)
  }
  
  var apiUrl = "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0"
  let nextPage = BehaviorSubject(value: [Int]())
  let ids = BehaviorSubject(value: [Int]())
  let disposeBag = DisposeBag()
  
  func getPokemonId(pokemonUrl: String) {
    guard let url = URL(string: pokemonUrl) else {
      ids.onError(NetworkError.invalidUrl)
      return
    }
    
    NetworkManager.shared.dataFetch(url: url)
      .subscribe(onSuccess: { [weak self] (pokemon: PokemonData) in
        let pokemonResults = pokemon.results
        let pokemonIds = pokemonResults.compactMap { pokemon -> Int? in
          return Int(pokemon.url.split(separator: "/").last ?? "")
        }
        
        do {
          var currentValue = try! self?.ids.value()
          currentValue?.append(contentsOf: pokemonIds)
          self?.ids.onNext(currentValue ?? [])
        }
      }, onFailure: { [weak self] error in
        self?.ids.onError(error)
      }).disposed(by: disposeBag)
  }
  
  func getNextPokemon(pokemonUrl: String) {
    guard let url = URL(string: apiUrl) else {
      nextPage.onError(NetworkError.invalidUrl)
      return
    }
    
    NetworkManager.shared.dataFetch(url: url)
      .subscribe(onSuccess: { [weak self] (pokemon: PokemonData) in
        self?.apiUrl = pokemon.next ?? ""
        self?.getPokemonId(pokemonUrl: pokemon.next ?? "")
      }, onFailure: { error in
        print(error)
      }).disposed(by: disposeBag)
  }
}
