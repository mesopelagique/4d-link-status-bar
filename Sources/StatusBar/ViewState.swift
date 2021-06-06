import Foundation
import QuatreD

struct ViewState: Equatable {
    var urls: Favorites.Value
}

extension ViewState {
    static func state(_ state: State) -> ViewState {
        .init(urls: state.urls)
    }
}
