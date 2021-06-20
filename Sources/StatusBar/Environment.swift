import Foundation

public struct Environemnt {
    public init(
        urlOpener: @escaping (URL) -> Void,
        appTerminator: @escaping (Any?) -> Void,
        remoteBash: @escaping (String, Bool) -> Void,
        bash: @escaping ([String]) -> Void
    ) {
        self.urlOpener = urlOpener
        self.appTerminator = appTerminator
        self.remoteBash = remoteBash
        self.bash = bash
    }

    public var urlOpener: (URL) -> Void
    public var appTerminator: (Any?) -> Void
    public var remoteBash: (String, Bool) -> Void
    public var bash: ([String]) -> Void
}
