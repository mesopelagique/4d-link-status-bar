import Cocoa
import Combine
import ComposableArchitecture

public final class View {

    public init(store: Store<State, Action>) {
        self.store = store
        self.viewStore = .init(store.scope(state: ViewState.state))
        item.menu = menu
        viewStore.$state
            .sink(receiveValue: { [unowned self] in self.update(viewState: $0) })
            .store(in: &cancellables)
    }

    let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = NSMenu()

    private let store: Store<State, Action>
    private let viewStore: ViewStore<ViewState, Action>
    private var cancellables = Set<AnyCancellable>()

    private func update(viewState: ViewState) {
        if let url = Bundle(for: View.self).url(forResource: "4D-structure", withExtension: "png") {
            item.button?.image = NSImage(contentsOf: url)
        } else {
            item.button?.title = "🖇"
        }

        menu.items = []
        if !viewState.urls.isEmpty {
            let urlByVersion = viewState.urls
            for (version, urls) in urlByVersion {
                let subMenuItem = MenuItem(title: version, action: {})
                let subMenu = NSMenu()
                subMenuItem.submenu = subMenu
                subMenu.items.append(contentsOf: urls.map(menuItem(for:)))
                menu.items.append(subMenuItem)
            }
            menu.items.append(.separator())
        }
        menu.items.append(MenuItem(title: "Refresh", action: { [weak self] in
            self?.viewStore.send(.refresh)
        }))
        menu.items.append(MenuItem(title: "Quit", action: { [weak self] in
            self?.viewStore.send(.quit)
        }))
    }

    private func menuItem(for url: URL) -> NSMenuItem {
        MenuItem(title: url.deletingPathExtension().lastPathComponent, action: { [weak self] in
            self?.viewStore.send(.openURL(url: url))
        })
    }

}
