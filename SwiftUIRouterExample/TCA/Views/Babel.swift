import Combine
import ComposableArchitecture
import SwiftUI

struct BabelView: View {
  @ObservedObject
  private var viewStore: BabelViewStore
  private let store: BabelStore

  @State var isOn: Bool = false
  @State var isOn2: Bool = false

  init(store: BabelStore) {
    self.store = store
    self.viewStore = ViewStore(store)
  }

  var body: some View {
    ZStack {
      Color.blue
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      VStack {
        Text("Babel Babel")
      }
    }
  }
}

typealias BabelStore = Store<BabelState, BabelAction>
typealias BabelViewStore = ViewStore<BabelState, BabelAction>

// MARK: Preview

struct BabelView_Previews: PreviewProvider {

  static var previews: some View {
    ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
      BabelView(store: store)
        .preferredColorScheme(colorScheme)
        .previewLayout(.sizeThatFits)
    }
  }

  static let store: BabelStore = .init(
    initialState: .init(),
    reducer: .init(),
    environment: .live
  )
}


// MARK: - State

public struct BabelState: Equatable {
  public init() {
  }
}

// MARK: - Action

enum BabelAction: Equatable {
  case onLoad
}

// MARK: - Reducer

typealias BabelReducer = Reducer<BabelState, BabelAction, BabelEnvironment>

extension BabelReducer {
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

struct BabelEnvironment {
  static var live: Self {
    return Self()
  }
}
