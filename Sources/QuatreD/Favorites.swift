import Foundation
import Combine

public struct Favorites {
    public static var pathExtension = "4DLink"
    public static var favoritePrefix = "Favorites "
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
            for url in folders.filter ({ $0.lastPathComponent.starts(with: favoritePrefix)}) {
                let version = url.lastPathComponent.replacingOccurrences(of: favoritePrefix, with: "") // XXX clean only first or do substring
                urls[version] = []
                if let files = try? FileManager.default.contentsOfDirectory(at: url.appendingPathComponent("Local"), includingPropertiesForKeys: [.isRegularFileKey], options: []) {
                    urls[version]?.append(contentsOf: files.filter { $0.pathExtension == pathExtension }.sorted(by: { $0.contentModificationDate > $1.contentModificationDate}))
                }
                if let files = try? FileManager.default.contentsOfDirectory(at: url.appendingPathComponent("Remote"), includingPropertiesForKeys: [.isRegularFileKey], options: []) {
                    urls[version]?.append(contentsOf: files.filter { $0.pathExtension == pathExtension }.sorted(by: { $0.contentModificationDate > $1.contentModificationDate}))
                }
            }
            promise(.success(urls))
        }.eraseToAnyPublisher()


    }
}

extension URL {

    var contentModificationDate: Date {
        assert(isFileURL)
        let fileUrl = self
        do {
            return try fileUrl.resourceValues(forKeys: Set([URLResourceKey.contentModificationDateKey])).contentModificationDate ?? Date()
        } catch let error as NSError {
            print("\(#function) Error: \(error)")
            return Date()
        }
    }
}
