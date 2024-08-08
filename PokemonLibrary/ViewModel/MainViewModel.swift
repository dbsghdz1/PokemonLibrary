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
import RxCocoa

protocol ViewModelType {
  associatedtype Input
  associatedtype Output
  
  func transform(input: Input) -> Output
}

final class MainViewModel: ViewModelType {
  
  struct Input {
    var isScrolled: Observable<Void>
  }
  
  struct Output {
    var pokemonIds: Driver<[Int]>
  }
  
  private let apiUrl = BehaviorRelay(value: "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0")
  let ids = BehaviorRelay(value: [Int]())
  private let disposeBag = DisposeBag()
  
  func transform(input: Input) -> Output {
    let pokemonIds = BehaviorRelay(value: ids.value)
    input.isScrolled
      .flatMapLatest { [weak self] _ -> Single<[Int]> in
        guard let self = self else { return .just([]) }
        return self.getPokemonId(pokemonUrl: self.apiUrl.value)
      }
      .subscribe(onNext: { [weak self] newIds in
        guard let self = self else { return }
        let updatedIds = self.ids.value + newIds
        self.ids.accept(updatedIds)
        pokemonIds.accept(updatedIds)
      }).disposed(by: disposeBag)
    
    return Output(pokemonIds: pokemonIds.asDriver(onErrorJustReturn: []))
  }
  
  private func getPokemonId(pokemonUrl: String) -> Single<[Int]> {
    guard let url = URL(string: pokemonUrl) else {
      return Single.error(NetworkError.invalidUrl)
    }
    
    return NetworkManager.shared.dataFetch(url: url)
      .map { (pokemon: PokemonData) -> [Int] in
        let pokemonResults = pokemon.results
        let pokemonIds = pokemonResults.compactMap { pokemon -> Int? in
          return Int(pokemon.url.split(separator: "/").last ?? "")
        }
        self.apiUrl.accept(pokemon.next ?? "")
        return pokemonIds
      }
  }
}
