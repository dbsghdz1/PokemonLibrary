//
//  SceneDelegate.swift
//  PokemonLibrary
//
//  Created by 김윤홍 on 8/4/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
   
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    let firstViewController = MainViewController()
    firstViewController.moveNextPage = { image, indexPath in
      let secondViewController = DetailViewController()
      secondViewController.receivedImage = image
      secondViewController.receivedIndexPath = indexPath
      firstViewController.navigationController?.pushViewController(secondViewController, animated: true)
    }
    let navigationController = UINavigationController(rootViewController: firstViewController)
    
    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
  }
}

