import Foundation

public enum Action: Equatable {
    case openURL(url: URL)
    case refresh
    case quit
}
