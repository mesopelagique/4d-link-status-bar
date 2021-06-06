import Foundation
import QuatreD

public struct State: Equatable {
    public init(urls: Favorites.Value = [:]) {
        self.urls = urls
    }

    public var urls: Favorites.Value
}
