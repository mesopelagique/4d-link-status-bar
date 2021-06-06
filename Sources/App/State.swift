import Foundation
import StatusBar
import QuatreD

public struct State: Equatable {
    public init(urls: Favorites.Value = [:]) {
        self.urls = urls
    }

    public var urls: Favorites.Value
}

extension State {
    var statusBar: StatusBar.State {
        get { .init(urls: urls) }
        set { urls = newValue.urls }
    }
}
