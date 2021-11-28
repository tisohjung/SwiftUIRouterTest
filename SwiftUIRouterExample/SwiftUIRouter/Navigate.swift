//
//  SwiftUI Router
//  Created by Freek Zijlmans on 13/01/2021.
//

import SwiftUI

/// When rendered will automatically perform a navigation to the given path.
///
/// This view allows you to pragmatically navigate to a new path in a View's body.
///
/// ```swift
/// SwitchRoutes {
/// 	Route(path: "news") { NewsView() }
/// 	Route {
/// 		// If this Route gets rendered redirect
/// 		// the user to a 'not found' screen.
/// 		Navigate(to: "/not-found")
/// 	}
/// }
/// ```
///
/// - Note: The given path is always relative to the current route environment. See the documentation for `Route` about
/// the specifics of path relativity.
public struct Navigate: View {

	@EnvironmentObject private var navigator: Navigator
	@Environment(\.relativePath) private var relativePath

	private let path: String

	private let replace: Bool

	/// - Parameter path: New path to navigate to once the View is rendered.
	public init(to path: String, replace: Bool = true) {
		self.path = path
		self.replace = replace
	}

	public var body: some View {
		Text("Navigating...")
			.hidden()
			.onAppear {
				if navigator.path != path {
					navigator.navigate(resolvePaths(relativePath, path), replace: replace)
				}
			}
	}
}
