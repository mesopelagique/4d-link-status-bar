import Combine
import ComposableArchitecture
import StatusBar

public typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

public let reducer = Reducer.combine(
    Reducer { state, action, env in
        switch action {
        case .fetchURLs,
             .statusBar(.refresh):
            return env.fetchURLs()
                .map(Action.didFetchURLs)
                .receive(on: env.mainQueue)
                .eraseToEffect()

        case .didFetchURLs(let urls):
            state.urls = urls
            return .none

        case .statusBar(_):
            return .none
        }
    },
    StatusBar.reducer.pullback(
        state: \.statusBar,
        action: /Action.statusBar,
        environment: \.statusBar
    )
)
