import SwiftUI

import ComposableArchitecture

typealias DeepLinkReducer = Reducer<
  TCAMainState,
  TCAMainAction,
  TCAMainEnvironment
>

let deepLinkReducer: DeepLinkReducer = .init { state, action, _ in
  switch action {
  case .airbnb(.onAirbnb):
    return .init(value: .navigate("airbnb"))

  case .airbnb(.onApple):
    return .init(value: .navigate("apple"))

  case .airbnb(.navigate(let path)):
    return .init(value: .navigate(path))

  case .airbnb:
    return .none

  case .apple:
    return .none

  case .babel:
    return .none

  case .moveToAirbnb(let shouldActivate):
    state.airbnb = shouldActivate ? .init() : nil
    return .init(value: .navigate("/airbnb"))

  case .moveToApple(let shouldActivate):
    state.apple = shouldActivate ? .init() : nil
    return .init(value: .navigate("/apple"))

  case .moveToBabel(let shouldActivate):
    state.babel = shouldActivate ? .init() : nil
    return .init(value: .navigate("/babel"))

  case .pop(let count):
    state.navigator?.goBack(total: count)
    return .none

  case .setNavigator(let navigator):
    state.navigator = navigator
    return .none

  case .navigate(let path):
    if path.contains("airbnb") && state.airbnb == nil {
      state.airbnb = .init()
    }
    if path.contains("apple") && state.apple == nil {
      state.apple = .init()
    }
    if path.contains("babel") && state.babel == nil {
      state.babel = .init()
    }
    state.navigator?.navigate(path, replace: false)
    return .none

  case .clearNavigationPathHistory:
    state.navigator?.clear()
    return .none

  default:
    return .none
  }
}
