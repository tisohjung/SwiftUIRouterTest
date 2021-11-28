import SwiftUI

struct Constants {
  static let navHeight: CGFloat = 50
}

struct OuterView: View {
  var body: some View {
    GeometryReader { proxy in
      let topSafeArea = proxy.safeAreaInsets.top
      StickyHeaderScrollView(topSafeArea: topSafeArea)
        .ignoresSafeArea(.all, edges: .top)
    }
  }
}

struct StickyHeaderScrollView: View {
  let minVisibleOffset: CGFloat = 70
  let maxHeight: CGFloat = 400
  let backgroundColor: some View = Color.blue
  let topSafeArea: CGFloat
  @State var offset: CGFloat = 0
  let title: String = "Hello title"

  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(spacing: 0) {
        // Top Nav View..
        GeometryReader { _ in
          TopBar(
            title: title,
            topSafeArea: topSafeArea,
            offset: $offset,
            maxHeight: maxHeight,
            minVisibleOffset: minVisibleOffset
          )
          .foregroundColor(Color.white)
          .frame(maxWidth: .infinity)
          .frame(height: getHeaderHeight(), alignment: .bottom)
          .background(
            Color.blue
//            in: CustomCorner(corners: [.bottomRight], radius: getCornerRadius())
          )
          .overlay(
            CollapsedMenu(
              title: title,
              topSafeArea: topSafeArea,
              titleOpacity: topBarTitleOpacity()
            ),
            alignment: .top
          )
        }
        .frame(height: maxHeight)
        .offset(y: -offset)
        .zIndex(1)

        VStack(spacing: 15) {
          ForEach(allMessages) { message in
            MessageCardView(message: message)
          }
        }
        .padding()
        .zIndex(0)
      }
      .modifier(OffsetModifier(offset: $offset))
    }
    .coordinateSpace(name: CoordinateSpace.stickyHeaderScrollView)
  }

  /// Header height is stretched when pulled down
  func getHeaderHeight() -> CGFloat {
    let topHeight = maxHeight + offset

    return topHeight > (Constants.navHeight + topSafeArea)
      ? topHeight
      : (Constants.navHeight + topSafeArea)
  }

  /// cornerRadius should disappear when scrolled up
  func getCornerRadius() -> CGFloat {
    let progress = 1 + offset / (maxHeight - (Constants.navHeight + topSafeArea))
    let radius = progress * 50
    return offset < 0 ? radius : 50
  }

  /// topBar should appear when scrolled up
  func topBarTitleOpacity() -> CGFloat {
//    let progress = -(offset + minVisibleOffset) / (maxHeight - (Constants.navHeight + topSafeArea))
//    return progress
//    let opacity = 1 - progress
//    return opacity
    let progress = -offset / minVisibleOffset
//    let opacity = 1 - progress
//    return offset < 0 ? opacity : 1
    return progress > 1 ? 1 : progress
  }
}

// MARK: Preview

struct StickyHeaderScrollView_Previews: PreviewProvider {

  static var previews: some View {
    ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
      OuterView()
        .preferredColorScheme(colorScheme)
        .previewLayout(.sizeThatFits)
    }
  }
}

struct TopBar: View {
  var title: String
  var topSafeArea: CGFloat
  @Binding var offset: CGFloat
  var maxHeight: CGFloat
  var minVisibleOffset: CGFloat

  var body: some View {
    VStack(alignment: .leading, spacing: 15) {
      Color.red
        .frame(width: 80, height: 80)
        .cornerRadius(10)
      Text(title)
        .font(.largeTitle.bold())
      Text(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent gravida elit vitae quam consequat ullamcorper. Vestibulum turpis est, congue ut posuere"
      )
      .fontWeight(.semibold)
    }
    .padding()
    .padding(.bottom)
    .opacity(getOpacity())
  }

  /// hide when scrolled up
  func getOpacity() -> CGFloat {
    // minVisibleOffset = time visible on scroll
    let progress = -offset / minVisibleOffset
    let opacity = 1 - progress
    return offset < 0 ? opacity : 1
  }
}

struct CustomCorner: Shape {
  var corners: UIRectCorner
  var radius: CGFloat

  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    return Path(path.cgPath)
  }
}

/// Getting Scrollview offset
struct OffsetModifier: ViewModifier {
  @Binding var offset: CGFloat

  func body(content: Content) -> some View {
    content.overlay(
      GeometryReader { proxy -> Color in
        let minY = proxy.frame(in: .stickyHeaderScrollView).minY

        DispatchQueue.main.async {
          self.offset = minY
        }
        return Color.clear
      }
    )
  }
}

extension CoordinateSpace {
  static var stickyHeaderScrollView: Self {
    return self.named("stickyHeaderScrollView")
  }
}

struct Message: Identifiable {
  var id = UUID().uuidString
  var message: String
  var userName: String
  var tintColor: Color
}

var allMessages: [Message] = [
  Message(message: "Can we go to the park", userName: "iJustin", tintColor: .pink),
  Message(message: "Can we go to the park", userName: "iJustin", tintColor: .orange),
  Message(message: "Can we go to the park", userName: "iJustin", tintColor: .green),
  Message(message: "Can we go to the park", userName: "iJustin", tintColor: .pink),
  Message(message: "Can we go to the park", userName: "iJustin", tintColor: .orange),
  Message(message: "Can we go to the park", userName: "iJustin", tintColor: .green),
  Message(message: "Can we go to the park", userName: "iJustin", tintColor: .pink),
  Message(message: "Can we go to the park", userName: "iJustin", tintColor: .orange),
  Message(message: "Can we go to the park", userName: "iJustin", tintColor: .green),
  Message(message: "Can we go to the park", userName: "iJustin", tintColor: .pink),
  Message(message: "Can we go to the park", userName: "iJustin", tintColor: .orange),
  Message(message: "Can we go to the park", userName: "iJustin", tintColor: .green),
  Message(message: "Can we go to the park", userName: "iJustin", tintColor: .pink),
  Message(message: "Can we go to the park", userName: "iJustin", tintColor: .orange),
  Message(message: "Can we go to the park", userName: "iJustin", tintColor: .green),
  Message(message: "Can we go to the park", userName: "iJustin", tintColor: .pink),
  Message(message: "Can we go to the park", userName: "iJustin", tintColor: .orange),
  Message(message: "Can we go to the park", userName: "iJustin", tintColor: .green)
]

struct MessageCardView: View {
  var message: Message

  var body: some View {
    HStack(spacing: 15) {
      Circle()
        .fill(message.tintColor)
        .frame(width: 50, height: 50)
        .opacity(0.8)

      VStack(alignment: .leading, spacing: 8) {
        Text(message.userName)
          .fontWeight(.bold)
        Text(message.message)
          .foregroundColor(.secondary)
      }
      .foregroundColor(.primary)
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

struct CollapsedMenu: View {
  var title: String
  var topSafeArea: CGFloat
  var titleOpacity: CGFloat

  var body: some View {
    HStack(spacing: 15) {
      Button {

      } label: {
        Image(systemName: "chevron.left")
          .font(.body.bold())
      }
      Spacer()
      Text(title)
        .opacity(titleOpacity)
      Spacer()
      Button {

      } label: {
        Image(systemName: "line.3.horizontal")
          .font(.body.bold())
      }
    }
    .padding(.horizontal)
    .frame(height: Constants.navHeight)
    .foregroundColor(.white)
    //              .background(Color.purple)
    .padding(.top, topSafeArea)
  }
}
