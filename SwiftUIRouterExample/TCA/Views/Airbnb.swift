import Combine
import ComposableArchitecture
import SwiftUI

struct AirbnbView: View {
  @ObservedObject
  private var viewStore: AirbnbViewStore
  private let store: AirbnbStore

  @State var isOn: Bool = false
  @State var isOn2: Bool = false

  init(store: AirbnbStore) {
    self.store = store
    self.viewStore = ViewStore(store)
  }

  var body: some View {
    ZStack {
//      Color.red
//        .frame(maxWidth: .infinity, maxHeight: .infinity)

      SwitchRoutes {
        Route(path: "apple") {
          ZStack {
            Color.red.frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
              Text("Airbnb > Apple")
              Button("/airbnb") {
                viewStore.send(.navigate("/airbnb"))
              }
              Button("/airbnb") {
                viewStore.send(.navigate(".."))
              }
            }
          }
        }
        .navigationTransition()
        Route(path: "airbnb") {
          ZStack {
            Color.blue.frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
              Text("Airbnb > Airbnb")
            }
          }
        }
        .navigationTransition()
        Route {
          VStack {
            Text("Airbnb")
            Toggle("", isOn: $isOn)
            Toggle("", isOn: $isOn2)
            Button("apple") {
              viewStore.send(.onApple)
            }
            Button("airbnb") {
              viewStore.send(.onAirbnb)
            }
            Button("babel") {
              viewStore.send(.navigate("babel"))
            }
            Button("/babel") {
              viewStore.send(.navigate("/babel"))
            }
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
      .navigationTransition()
    }
  }
}

typealias AirbnbStore = Store<AirbnbState, AirbnbAction>
typealias AirbnbViewStore = ViewStore<AirbnbState, AirbnbAction>

// MARK: Preview

struct AirbnbView_Previews: PreviewProvider {

  static var previews: some View {
    ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
      AirbnbView(store: store)
        .preferredColorScheme(colorScheme)
        .previewLayout(.sizeThatFits)
    }
  }

  static let store: AirbnbStore = .init(
    initialState: .init(),
    reducer: .init(),
    environment: .live
  )
}

// MARK: - State

public struct AirbnbState: Equatable {
  public init() {
  }
}

// MARK: - Action

enum AirbnbAction: Equatable {
  case onLoad
  case onApple
  case onAirbnb
  case navigate(String)
}

// MARK: - Reducer

typealias AirbnbReducer = Reducer<AirbnbState, AirbnbAction, AirbnbEnvironment>

extension AirbnbReducer {
  init() {
    self = Self
      .combine(
        .init { _, action, _ in
          switch action {
          case .onLoad:
            return .none

          case .onApple:
            return .none

          case .onAirbnb:
            return .none

          case .navigate(_):
            return .none
          }
        }
      )
      .debug()
  }
}

// MARK: - Environment

struct AirbnbEnvironment {
  static var live: Self {
    return Self()
  }
}
