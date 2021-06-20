import App
import Cocoa
import ComposableArchitecture
import Combine
import QuatreD
import Appify
import Bash

Appify.run()

let app: NSApplication = .shared
let appView: View = .init(store: .init(
    initialState: .init(),
    reducer: reducer,
    environment: .init(
        fetchURLs: { Favorites.get() },
        urlOpener: { NSWorkspace.shared.open($0) },
        appTerminator: app.terminate(_:),
        remoteBash: { remoteBash($0, $1) },
        bash: { bash(args: $0) },
        mainQueue: AnyScheduler(DispatchQueue.main)
    )
), imageURL: Bundle.module.url(forResource: "4D-structure", withExtension: "png"))

NSApp.setActivationPolicy(.accessory)
app.delegate = appView
app.run()
