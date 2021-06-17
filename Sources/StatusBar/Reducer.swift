import ComposableArchitecture
import Foundation

public typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environemnt>

public let reducer = Reducer { state, action, env in
    switch action {
    case .openURL(let url):
        return .fireAndForget { [state] in
            env.urlOpener(url)
        }
    case .settings:
        return .none
    case .refresh:
        return .none
    case .quit:
        return .fireAndForget {
            env.appTerminator(nil)
        }
    }
}
