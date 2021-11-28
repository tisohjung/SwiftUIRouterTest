import SwiftUI


import SwiftUI

struct TCAMainView: View {
  @ObservedObject private var viewStore: TCAMainViewStore
  private let store: TCAMainStore

  @EnvironmentObject private var navigator: Navigator
  @Environment(\.relativePath) private var relativePath

  init(store: TCAMainStore) {
    self.store = store
    self.viewStore = ViewStore(store)
  }

  var body: some View {
    VStack {
      AddressBar()
      SwitchRoutes {
        //          Route(path: "/:name") { info in
        //            //      RepositoriesRoute(name: info.parameters.name!)
        //            ZStack {
        //              Color.gray.frame(maxWidth: .infinity, maxHeight: .infinity)
        //              VStack {
        //                Text(info.parameters["name"]!)
        //                NavLink(to: "/" + "google") {
        //                  Text("go to Google")
        //                }
        //              }
        //            }
        //          }.navigationTransition()

        Route(path: "/airbnb/*") {
          IfLetStore(
            self.store.scope(
              state: \.airbnb,
              action: TCAMainAction.airbnb
            ),
            then: AirbnbView.init(store:)
          )
        }
        .navigationTransition()
        Route(path: "/apple/*") {
          IfLetStore(
            self.store.scope(
              state: \.apple,
              action: TCAMainAction.apple
            ),
            then: AppleView.init(store:)
          )
        }
        .navigationTransition()
        Route(path: "/babel") {
          ZStack {
            Color.gray.frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
              Button("pop") {
                viewStore.send(.pop(1))
              }
              Text("babel")
              NavLink(to: "/" + "google") {
                Text("go to Google")
              }
            }
          }
        }

        Route {
          VStack {
            Button("go to Airbnb") {
              viewStore.send(.moveToAirbnb(true))
            }
            Button("go to /airbnb/apple") {
              viewStore.send(.navigate("/airbnb/apple"))
            }
            Button("go to Apple") {
              viewStore.send(.moveToApple(true))
            }
            Button("go to Babel") {
              viewStore.send(.moveToBabel(true))
            }
            Spacer()
            //            NavLink(to: "/apple") {
            //              Text("go to Apple")
            //            }
            //            NavLink(to: "/airbnb") {
            //              Text("go to Airbnb")
            //            }
            //            NavLink(to: "/babel") {
            //              Text("go to Babel")
            //            }
            Spacer()
          }
        }.navigationTransition()
      }
    }
    .onAppear {
      print("@@@ onAppear : \(navigator)")
      viewStore.send(.setNavigator(navigator))
    }
  }
}

// MARK: Preview

struct TCAMain_Previews: PreviewProvider {

  static var previews: some View {
    ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
      TCAMainView(store: store)
        .preferredColorScheme(colorScheme)
        .previewLayout(.sizeThatFits)
    }
  }

  static let store: TCAMainStore = .init(
    initialState: .init(),
    reducer: .init(),
    environment: .live
  )
}


// MARK: Store

typealias TCAMainStore = Store<TCAMainState, TCAMainAction>

// MARK: ViewStore

typealias TCAMainViewStore = ViewStore<TCAMainState, TCAMainAction>

// MARK: Preview

struct TCAMainView_Previews: PreviewProvider {

  static var previews: some View {
    ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
      TCAMainView(store: store)
        .preferredColorScheme(colorScheme)
        .previewLayout(.sizeThatFits)
    }
  }

  static let store: TCAMainStore = .init(
    initialState: .init(navigator: Navigator()),
    reducer: .init(),
    environment: .live
  )
}

import Combine
import ComposableArchitecture

// MARK: - State

public struct TCAMainState: Equatable {
  var airbnb: AirbnbState?
  var apple: AppleState?
  var babel: BabelState?
  var navigator: Navigator?
}

// MARK: - Action

enum TCAMainAction: Equatable {
  case onLoad
  case airbnb(AirbnbAction)
  case apple(AppleAction)
  case babel(BabelAction)
  case moveToAirbnb(Bool)
  case moveToApple(Bool)
  case moveToBabel(Bool)
  case navigate(String)
  case pop(Int)
  case setNavigator(Navigator)
  case clearNavigationPathHistory
}

// MARK: - Reducer

typealias TCAMainReducer = Reducer<TCAMainState, TCAMainAction, TCAMainEnvironment>

extension TCAMainReducer {
  init() {
    self = Self
      .combine(
        AirbnbReducer().optional().pullback(
          state: \.airbnb,
          action: /TCAMainAction.airbnb,
          environment: { _ in .init() }
        ),
        AppleReducer().optional().pullback(
          state: \.apple,
          action: /TCAMainAction.apple,
          environment: { _ in .init() }
        ),
        BabelReducer().optional().pullback(
          state: \.babel,
          action: /TCAMainAction.babel,
          environment: { _ in .init() }
        ),
        .init { state, action, _ in
          print("Action : \(action)")
          switch action {
          case .onLoad:
            return .none

          default:
            return .none
          }
        },
        deepLinkReducer
      )
      .debug()
  }
}

// MARK: - Environment

struct TCAMainEnvironment {
  static var live: Self {
    return Self()
  }
}
