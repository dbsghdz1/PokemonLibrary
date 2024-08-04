//
//  NetworkManager.swift
//  PokemonLibrary
//
//  Created by 김윤홍 on 8/4/24.
//

//추후 알라모파이어 고려 concurrency 고려
import Foundation
import RxSwift

enum NetworkError: Error {
  case invalidUrl
  case dataFetchFail
  case decodingFail
}

class NetworkManager {
  static let sahred = NetworkManager()
  private init() {}
  
  func dataFetch<T: Decodable>(url: URL) -> Single<T> {
    return Single<T>.create { obsever in
      let session = URLSession(configuration: .default)
      session.dataTask(with: URLRequest(url: url)) { data, response, error in
        if let error = error {
          obsever(.failure(error))
          return
        }
        
        guard let data = data,
              let response = response as? HTTPURLResponse,
              (200..<300).contains(response.statusCode) else {
          obsever(.failure(NetworkError.dataFetchFail))
          return
        }
        do {
          let decodeData = try JSONDecoder().decode(T.self, from: data)
          obsever(.success(decodeData))
        } catch {
          obsever(.failure(NetworkError.decodingFail))
        }
      }.resume()
      return Disposables.create()
    }
  }
}
