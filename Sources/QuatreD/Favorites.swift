import Foundation
import Combine

public struct Favorites {
    public typealias Value = [String: [URL]]
    public static func get() -> AnyPublisher<Value, Never> {
        // return Just<[URL]>([]).eraseToAnyPublisher() // mock nothing
        return Future { promise in
            var urls: Value = [:]
            guard let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
                promise(.success(urls))
                return
            }
            guard let folders = try? FileManager.default.contentsOfDirectory(at: appSupport.appendingPathComponent("4D"), includingPropertiesForKeys: [.isDirectoryKey], options: []) else {
                promise(.success(urls))
                return
            }
            for url in folders.filter ({ $0.lastPathComponent.starts(with: "Favorites ")}) {
                let version = url.lastPathComponent.replacingOccurrences(of: "Favorites ", with: "")
                urls[version] = []
                if let files = try? FileManager.default.contentsOfDirectory(at: url.appendingPathComponent("Local"), includingPropertiesForKeys: [.isRegularFileKey], options: []) {
                    urls[version]?.append(contentsOf: files.filter { $0.pathExtension == "4DLink" })
                }
                if let files = try? FileManager.default.contentsOfDirectory(at: url.appendingPathComponent("Remote"), includingPropertiesForKeys: [.isRegularFileKey], options: []) {
                    urls[version]?.append(contentsOf: files.filter { $0.pathExtension == "4DLink" })
                }
            }
            promise(.success(urls))
        }.eraseToAnyPublisher()


    }
}
