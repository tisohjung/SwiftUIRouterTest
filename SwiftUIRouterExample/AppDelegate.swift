//
//  SwiftUIRouterApp.swift
//  SwiftUIRouter
//
//  Created by minho on 2021/11/19.
//

import SwiftUI

@main
struct SwiftUIRouterApp: App {
  var body: some Scene {
    WindowGroup {
      Router {
        RootView()
      }
    }
  }
}
