import SwiftUI

// Entry of the entire app.
struct RootView: View {
  @EnvironmentObject private var navigator: Navigator
  @Environment(\.relativePath) private var relativePath

  let store: TCAMainStore = .init(
    initialState: .init(),
    reducer: .init(),
    environment: .live
  )

  var body: some View {
//    contentView
    TCAMainView(store: store)
  }

  var contentView: some View {
    Router {
      VStack {
        AddressBar()
        ContentView()
      }
    }
  }
}
