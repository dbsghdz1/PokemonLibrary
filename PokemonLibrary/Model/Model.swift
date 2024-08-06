//
//  Model.swift
//  PokemonLibrary
//
//  Created by 김윤홍 on 8/4/24.
//

import Foundation

struct PokemonData: Codable {
  let results: [Pokemon]
}

struct Pokemon: Codable {
  let url: String
  //let next: String
}

struct PokemonInfo: Codable {
  let id: Int
  let name: String
  let height: Int
  let weight: Int
  let types: [PokemonType]
}

struct PokemonType: Codable {
  let type: TypeName
}

struct TypeName: Codable {
  let name: String
}
