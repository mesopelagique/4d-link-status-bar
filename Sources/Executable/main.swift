import App
import Cocoa
import ComposableArchitecture
import Combine
import QuatreD

let app: NSApplication = .shared
let appView: View = .init(store: .init(
    initialState: .init(),
    reducer: reducer,
    environment: .init(
        fetchURLs: { Favorites.get() },
        urlOpener: { NSWorkspace.shared.open($0) },
        appTerminator: app.terminate(_:),
        mainQueue: AnyScheduler(DispatchQueue.main)
    )
))

app.delegate = appView
app.run()
