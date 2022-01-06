//
//  From RouterExample
//
//  Created by Freek Zijlmans on 12/10/2019.
//  Copyright © 2019 Freek Zijlmans. All rights reserved.
//
import SwiftUI
import SwiftUIRouter

struct ContentView: View {
  private let suggestions: [(name: String, url: String)] = [
    ("Airbnb", "airbnb"),
    ("Apple", "apple"),
    ("Babel", "babel"),
    ("Google", "google"),
    ("Microsoft", "microsoft"),
    ("Nvidia", "nvidia"),
  ]

  let backgroundColors: [String: Color] = [
    "airbnb" : Color.gray,
    "apple" : Color.red,
    "babel" : Color.blue,
    "google" : Color.green,
    "microsoft" : Color.orange,
    "nvidia" : Color.pink
  ]

  var body: some View {
    SwitchRoutes {
      Route(path: "/:name") { info in
        //      RepositoriesRoute(name: info.parameters.name!)
        ZStack {
          Color.gray.frame(maxWidth: .infinity, maxHeight: .infinity)
          backgroundColors[info.parameters["name"]!]
            .frame(maxWidth: .infinity, maxHeight: .infinity)
          VStack {
            Text(info.parameters["name"]!)
            NavLink(to: "/" + "google") {
              Text("go to Google")
            }
          }
        }
      }.navigationTransition()

      Route {
        VStack {
          ForEach(suggestions, id: \.url) { suggestion in
            NavLink(to: "/" + suggestion.url) {
              Text(suggestion.name)
            }
          }
        }
        Spacer()
      }.navigationTransition()
    }
  }
}

struct AddressBar: View {

  @EnvironmentObject private var navigator: Navigator

  private func onBackPressed() {
    navigator.goBack()
  }

  private func onForwardPressed() {
    navigator.goForward()
  }

  private func onOpenPressed() {
    if let url = URL(string: "https://github.com" + navigator.path) {
      UIApplication.shared.open(url, options: [:])
    }
  }

  var body: some View {
    HStack {
      HStack {
        Text(navigator.path)
          .lineLimit(1)

        Spacer()
      }
      .padding(6)
      .background(Color.primary.opacity(0.08))
      .cornerRadius(5)

      Button(action: onBackPressed) {
        Image(systemName: "arrow.left.circle")
          .imageScale(.large)
          .padding(4)
      }
      .disabled(!navigator.canGoBack)

      Button(action: onForwardPressed) {
        Image(systemName: "arrow.right.circle")
          .imageScale(.large)
          .padding(4)
      }
      .disabled(!navigator.canGoForward)

      Button(action: onOpenPressed) {
        Image(systemName: "safari")
          .imageScale(.large)
          .padding(4)
      }
    }
    .padding()
  }
}

import Foundation
import SwiftUI

struct ActivityIndicator: UIViewRepresentable {

  var isAnimating: Bool

  func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
    return UIActivityIndicatorView(style: .large)
  }

  func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
    isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
  }
}
