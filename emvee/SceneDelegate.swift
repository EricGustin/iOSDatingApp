//
//  SceneDelegate.swift
//  FirebaseAuthentification
//
//  Created by Eric Gustin on 5/8/20.
//  Copyright © 2020 Eric Gustin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

 var window: UIWindow?


 func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
  // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
  // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
  // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
  guard let windowScene = (scene as? UIWindowScene) else { return }
  
  window = UIWindow(frame: windowScene.coordinateSpace.bounds)
  window?.windowScene = windowScene
  window?.makeKeyAndVisible()
  var vc = UIViewController()
  if Auth.auth().currentUser?.uid == nil {
    UserDefaults.standard.set(false, forKey: "isUserSignedIn")
    vc = WelcomeViewController()
  }
  if UserDefaults.standard.bool(forKey: "isUserSignedIn") {
    guard let userID = Auth.auth().currentUser?.uid else {
      print("Error accessing userID")
      vc = WelcomeViewController()
      UserDefaults.standard.set(false, forKey: "isUserSignedIn")
      let nc = NavigationController(vc)
      window?.rootViewController = nc
      nc.pushViewController(vc, animated: false)
      return
    }
    let db = Firestore.firestore()
    db.collection("onlineUsers").document(userID).setData(["userID": userID])
    vc = HomeViewController()
  }
  let nc = NavigationController(vc)
  window?.rootViewController = nc
  nc.pushViewController(vc, animated: false)
 }

 func sceneDidDisconnect(_ scene: UIScene) {
  // Called as the scene is being released by the system.
  // This occurs shortly after the scene enters the background, or when its session is discarded.
  // Release any resources associated with this scene that can be re-created the next time the scene connects.
  // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
 }

 func sceneDidBecomeActive(_ scene: UIScene) {
  // Called when the scene has moved from an inactive state to an active state.
  // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  print("Did become active")
  guard let userID = Auth.auth().currentUser?.uid else {
    print("Error accessing userID")
    return
  }
  let db = Firestore.firestore() // initialize an instance of Cloud Firestore
  // Add the user to the onlineUsers collection
    db.collection("onlineUsers").document(userID).setData(["userID": userID])
  print("successfully added user to onlineUsers collection")
 }

 func sceneWillResignActive(_ scene: UIScene) {
  // Called when the scene will move from an active state to an inactive state.
  // This may occur due to temporary interruptions (ex. an incoming phone call).
 }

 func sceneWillEnterForeground(_ scene: UIScene) {
  // Called as the scene transitions from the background to the foreground.
  // Use this method to undo the changes made on entering the background.
 }

 func sceneDidEnterBackground(_ scene: UIScene) {
  // Called as the scene transitions from the foreground to the background.
  // Use this method to save data, release shared resources, and store enough scene-specific state information
  // to restore the scene back to its current state.
  print("Did enter background")
  guard let userID = Auth.auth().currentUser?.uid else {
    print("Error accessing userID")
    return
  }
  let db = Firestore.firestore() // initialize an instance of Cloud Firestore
  db.collection("onlineUsers").document(userID).delete() { err in
    if let err = err {
      print("Error removing document: \(err)")
    } else {
      print("OnlineUser successfully removed! in appdelegate")
    }
  }
 }


}

