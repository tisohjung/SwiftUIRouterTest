//
//  SwiftUIRouterApp.swift
//  SwiftUIRouter
//
//  Created by minho on 2021/11/19.
//

import SwiftUI
import SwiftUIRouter

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
