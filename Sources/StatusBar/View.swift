import Cocoa
import Combine
import ComposableArchitecture

public final class View {

    public init(store: Store<State, Action>, imageURL: URL?) {
        self.store = store
        self.viewStore = .init(store.scope(state: ViewState.state))
        item.menu = menu
        viewStore.$state
            .sink(receiveValue: { [unowned self] in self.update(viewState: $0) })
            .store(in: &cancellables)

        if let url = imageURL {
            item.button?.image = NSImage(contentsOf: url)
            item.button?.image?.isTemplate = true
        } else {
            item.button?.image = NSImage(systemSymbolName: "questionmark.square.dashed", accessibilityDescription: nil)
        }
    }

    let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = NSMenu()

    private let store: Store<State, Action>
    private let viewStore: ViewStore<ViewState, Action>
    private var cancellables = Set<AnyCancellable>()

    private func update(viewState: ViewState) {
        menu.items = []
        if !viewState.urls.isEmpty {
            let urlByVersion = viewState.urls
            for (version, urls) in urlByVersion {
                let subMenuItem = MenuItem(title: version, action: {})
                let subMenu = NSMenu()
                subMenuItem.submenu = subMenu
                let dico: [URL: [URL]] = Dictionary(grouping: urls) { $0.deletingLastPathComponent() }
                for (parent, urlDicos) in dico {
                    let parentItem = NSMenuItem(title: parent.lastPathComponent, action: nil, keyEquivalent: "")
                    parentItem.isEnabled = false
                    subMenu.items.append(parentItem)
                    subMenu.items.append(contentsOf: urlDicos.map(menuItem(for:)))
                    subMenu.items.append(.separator())
                }
                menu.items.append(subMenuItem)
            }
            menu.items.append(.separator())
        }
        
        let docMenuItem = MenuItem(title: "Links...", action: {})
        let subMenu = NSMenu()
        docMenuItem.submenu = subMenu
        subMenu.items.append(MenuItem(title: "Doc", action: { [weak self] in
            self?.viewStore.send(.openURL(url: URL(string: "https://developer.4d.com/")!))
        }))
        subMenu.items.append(MenuItem(title: "Blog", action: { [weak self] in
            self?.viewStore.send(.openURL(url: URL(string: "https://blog.4d.com/")!))
        }))
        subMenu.items.append(MenuItem(title: "Discuss", action: { [weak self] in
            self?.viewStore.send(.openURL(url: URL(string: "https://discuss.4d.com/")!))
        }))
        subMenu.items.append(MenuItem(title: "Get Support", action: { [weak self] in
            self?.viewStore.send(.openURL(url: URL(string: "https://taow.4d.com/")!))
        }))
        subMenu.items.append(MenuItem(title: "Download", action: { [weak self] in
            self?.viewStore.send(.openURL(url: URL(string: "https://us.4d.com/product-download/")!))
        }))
  
        menu.items.append(docMenuItem)
        menu.items.append(.separator())
        menu.items.append(MenuItem(title: "Refresh", action: { [weak self] in
            self?.viewStore.send(.refresh)
        }))
        /*menu.items.append(MenuItem(title: "Settings", action: { [weak self] in
            self?.viewStore.send(.settings)
        }))*/
        menu.items.append(.separator())
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
