import StatusBar
import Foundation
import QuatreD

public enum Action: Equatable {
    case fetchURLs
    case didFetchURLs(Favorites.Value)
    case statusBar(StatusBar.Action)
}
