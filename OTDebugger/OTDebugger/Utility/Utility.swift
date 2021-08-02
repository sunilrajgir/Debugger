//
//  Utility.swift
//  OTDebugger
//
//  Created by Sunil Kumar on 02/08/21.
//

import Foundation


class Utility {
    class func getCurrentDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let utcDate = dateFormatter.string(from: date)
        return utcDate
    }

    class func getCurrentTime() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH-mm-ss"
        dateFormatter.timeZone = .current
        var time = dateFormatter.string(from: date)
        time = time.replacingOccurrences(of: "/", with: "_")
        return time
    }
}

extension String {
    func appendToURL(fileURL: URL) throws {
        let data = self.data(using: String.Encoding.utf8)!
        try data.append(fileURL: fileURL)
    }
}

extension Data {
    func append(fileURL: URL) throws {
        if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write(self)
        }
        else {
            try write(to: fileURL, options: .atomic)
        }
    }
}

