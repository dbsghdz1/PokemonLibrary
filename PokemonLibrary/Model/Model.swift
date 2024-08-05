//
//  Model.swift
//  PokemonLibrary
//
//  Created by 김윤홍 on 8/4/24.
//

import Foundation

struct PokemonData: Codable {
  var results = [Name]()
}

struct Name: Codable {
  var url: String?
}

struct PokemonInfo: Codable {
  let id: String
  let name: String
  let height: Int
  let weight: Int
  let sprites: [Other]
}

struct Other: Codable {
  let dream_world: [PokemonImage]
}

struct PokemonImage: Codable {
  let front_default: String
}

