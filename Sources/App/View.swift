import Cocoa
import ComposableArchitecture
import StatusBar

public final class View: NSObject, NSApplicationDelegate {

    public init(store: Store<State, Action>, imageURL: URL?) {
        self.store = store
        self.imageURL = imageURL
        super.init()
    }

    private(set) var statusBarView: StatusBar.View?

    public func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarView = .init(store: store.scope(
            state: \.statusBar,
            action: Action.statusBar
        ), imageURL: imageURL)

        ViewStore(store).send(.fetchURLs)
    }

    private let store: Store<State, Action>
    private let imageURL: URL?

}
