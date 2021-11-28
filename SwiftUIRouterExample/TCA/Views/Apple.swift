import Combine
import ComposableArchitecture
import SwiftUI

struct AppleView: View {
  @ObservedObject
  private var viewStore: AppleViewStore
  private let store: AppleStore

  @State var isOn: Bool = false
  @State var isOn2: Bool = false

  init(store: AppleStore) {
    self.store = store
    self.viewStore = ViewStore(store)
  }

  var body: some View {
    ZStack {
      SwitchRoutes {
        Route(path: "apple") {
          ZStack {
            Color.blue.frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
              Text("Apple > Blue")
            }
          }
        }
        .navigationTransition()
        Route(path: "airbnb") {
          ZStack {
            Color.green.frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
              Text("Apple > Green")
            }
          }
        }
        .navigationTransition()
        Route {
          VStack {
            Text("Apple")
            Toggle("", isOn: $isOn)
            Toggle("", isOn: $isOn2)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTransition()
      }
    }
  }
}

typealias AppleStore = Store<AppleState, AppleAction>
typealias AppleViewStore = ViewStore<AppleState, AppleAction>

// MARK: Preview

struct AppleView_Previews: PreviewProvider {

  static var previews: some View {
    ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
      AppleView(store: store)
        .preferredColorScheme(colorScheme)
        .previewLayout(.sizeThatFits)
    }
  }

  static let store: AppleStore = .init(
    initialState: .init(),
    reducer: .init(),
    environment: .live
  )
}


// MARK: - State

public struct AppleState: Equatable {
  public init() {
  }
}

// MARK: - Action

enum AppleAction: Equatable {
  case onLoad
}

// MARK: - Reducer

typealias AppleReducer = Reducer<AppleState, AppleAction, AppleEnvironment>

extension AppleReducer {
  init() {
    self = Self
      .combine(
        .init { _, action, _ in
          switch action {
          case .onLoad:
            return .none
          }
        }
      )
      .debug()
  }
}

// MARK: - Environment

struct AppleEnvironment {
  static var live: Self {
    return Self()
  }
}
