import Cocoa
import Combine
import ComposableArchitecture
import Bash

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
        menu.items.append(MenuItem(title: "Refresh", action: { [weak self] in
            self?.viewStore.send(.refresh)
        }))
        menu.items.append(.separator())
        let docMenuItem = MenuItem(title: "Links...", action: {})
        let docMenuItemMenu = NSMenu()
        docMenuItem.submenu = docMenuItemMenu
        for (title, url) in [
            ("Doc","https://developer.4d.com/"),
            ("Blog", "https://blog.4d.com/"),
            ("Discuss", "https://discuss.4d.com/"),
            ("Get Support", "https://taow.4d.com/"),
            ("Download", "https://us.4d.com/product-download/")
        ] {
            docMenuItemMenu.items.append(MenuItem(title: title, action: { [weak self] in
                self?.viewStore.send(.openURL(url: URL(string: url)!))
            }))
        }
        
        menu.items.append(docMenuItem)

        /*menu.items.append(MenuItem(title: "Settings", action: { [weak self] in
            self?.viewStore.send(.settings)
        }))*/
        menu.items.append(.separator())
        menu.items.append(MenuItem(title: "Update app", action: { [weak self] in
            self?.viewStore.send(.remoteBash(url: "https://mesopelagique.github.io/4d-link-status-bar/install.sh", admin: false))
        }))

        let toolsMenuItem = MenuItem(title: "Other tools", action: {})
        let toolsMenuItemMenu = NSMenu()
        toolsMenuItem.submenu = toolsMenuItemMenu
        menu.items.append(toolsMenuItem)
        
        /*let cmdInstalled = FileManager.default.fileExists(atPath: "/usr/local/bin/4d")
        toolsMenuItemMenu.items.append(MenuItem(title: "Install 4d cmd", action: { [weak self] in
            self?.viewStore.send(.remoteBash(url: "https://mesopelagique.github.io/kaluza-cli/install.sh", admin: true))
        }))*/

        let kaluzaInstalled = FileManager.default.fileExists(atPath: "/usr/local/bin/kaluza")
        if kaluzaInstalled {
            let kaluzaMenuItem = MenuItem(title: "Kaluza", action: {})
            let kaluzaMenuItemMenu = NSMenu()
            kaluzaMenuItem.submenu = kaluzaMenuItemMenu
            kaluzaMenuItemMenu.items.append(MenuItem(title: "Update kaluza", action: { [weak self] in
                self?.viewStore.send(.remoteBash(url: "https://mesopelagique.github.io/kaluza-cli/install.sh", admin: true))
            }))
           /* kaluzaMenuItemMenu.items.append(MenuItem(title: "List", action: { [weak self] in
                self?.viewStore.send(.bash(args: ["-c", "/usr/local/bin/kaluza list -g"]))
            }))*/
            let installed = Bash.bash("-c", "/usr/local/bin/kaluza list -g")
            kaluzaMenuItemMenu.items.append(MenuItem(title: "Install configured", toolTip: installed, action: { [weak self] in
                self?.viewStore.send(.bash(args: ["-c", "/usr/local/bin/kaluza install -g"]))
            }))
            
            let install4DPopList = ["4DPop", "4DPop-Macros", "4DPop-XLIFF-Pro", "4DPop-Git", "4DPop-ColorChart", "4DPop-Image-Buddy"]
            kaluzaMenuItemMenu.items.append(MenuItem(title: "Install 4dpop", toolTip: install4DPopList.joined(separator: "\n"), action: { [weak self] in
                for install4DPop in install4DPopList {
                    self?.viewStore.send(.bash(args: ["-c", "/usr/local/bin/kaluza install -g vdelachaux/\(install4DPop)"]))
                }
            }))
            let mesoToolsList = ["OpenIn", "DeployComponent", "Blame4D", "Mark4Down"]
            kaluzaMenuItemMenu.items.append(MenuItem(title: "Install mesotools", toolTip: mesoToolsList.joined(separator: "\n"), action: { [weak self] in
                for mesoToolin in mesoToolsList {
                    self?.viewStore.send(.bash(args: ["-c", "/usr/local/bin/kaluza install -g mesopelagique/\(mesoToolin)"]))
                }
            }))
            toolsMenuItemMenu.items.append(kaluzaMenuItem)
        } else {
            toolsMenuItemMenu.items.append(MenuItem(title: "Install Package Manager", action: { [weak self] in
                self?.viewStore.send(.remoteBash(url: "https://mesopelagique.github.io/kaluza-cli/install.sh", admin: true))
            }))
        }
  
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
