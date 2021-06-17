import Foundation

public enum Action: Equatable {
    case openURL(url: URL)
    case settings
    case refresh
    case quit
}
