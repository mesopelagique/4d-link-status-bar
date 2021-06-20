import Foundation

public enum Action: Equatable {
    case openURL(url: URL)
    case remoteBash(url: String, admin: Bool)
    case bash(args: [String])
    case settings
    case refresh
    case quit
}
