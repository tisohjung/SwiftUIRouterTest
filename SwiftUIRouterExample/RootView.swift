import SwiftUI
import SwiftUIRouter

// Entry of the entire app.
struct RootView: View {
  @EnvironmentObject private var navigator: Navigator

  let store: TCAMainStore = .init(
    initialState: .init(),
    reducer: .init(),
    environment: .live
  )

  var body: some View {
//    contentView
    NavigationView {
      TCAMainView(store: store)
    }
    .navigationViewStyle(.stack)
  }

  var contentView: some View {
    VStack {
      AddressBar()
      ContentView()
    }
  }
}
