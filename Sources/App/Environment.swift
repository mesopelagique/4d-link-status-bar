import ComposableArchitecture
import Foundation
import Combine
import StatusBar
import QuatreD

public struct Environment {
    public init(
        fetchURLs: @escaping (() -> AnyPublisher<Favorites.Value, Never>),
        urlOpener: @escaping (URL) -> Void,
        appTerminator: @escaping (Any?) -> Void,
        remoteBash: @escaping (String, Bool) -> Void,
        bash: @escaping ([String]) -> Void,
        mainQueue: AnySchedulerOf<DispatchQueue>
    ) {
        self.fetchURLs = fetchURLs
        self.urlOpener = urlOpener
        self.appTerminator = appTerminator
        self.remoteBash = remoteBash
        self.bash = bash
        self.mainQueue = mainQueue
    }

    public var fetchURLs: (() -> AnyPublisher<Favorites.Value, Never>)
    public var urlOpener: (URL) -> Void
    public var appTerminator: (Any?) -> Void
    public var remoteBash: (String, Bool) -> Void
    public var bash: ([String]) -> Void
    public var mainQueue: AnySchedulerOf<DispatchQueue>
}

extension Environment {
    var statusBar: StatusBar.Environemnt {
        .init(urlOpener: urlOpener, appTerminator: appTerminator, remoteBash: remoteBash, bash: bash)
    }
}
