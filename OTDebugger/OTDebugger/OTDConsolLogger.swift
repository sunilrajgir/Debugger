//
//  OTDConsolLogger.swift
//  OTDebugger
//
//  Created by Sunil Kumar on 02/08/21.
//

import Foundation


class OTDConsolLogger {
    private var logDirectory: URL?
    private var currentFolder: URL?
    private var currentLogFile: URL?
    private var logs = ""

    init(){
        createLogDirectory()
        createFolder()
        createCurrentLogFile()
    }

    private func createLogDirectory() {
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        logDirectory = dirPaths[0].appendingPathComponent("OTLogs")
    }

    private func createFolder() {
        var docsURL = logDirectory
        let currentDate = getCurrentDate()
        docsURL?.appendPathComponent(currentDate)
        if FileManager.default.fileExists(atPath: docsURL!.path) {
            currentFolder = docsURL
        } else {
            try? FileManager.default.createDirectory(at: docsURL!, withIntermediateDirectories: true, attributes: nil)
            currentFolder = docsURL
        }
    }

    private func createCurrentLogFile() {
        let currentTime = getCurrentTime()
        let url = currentFolder?.appendingPathComponent("\(currentTime).txt")
        currentLogFile = url
        try? "\(Date())".appendToURL(fileURL: currentLogFile!)
    }

    public func getCurrentLogFile() -> URL? {
        return currentLogFile
    }

    public func allLogDirectory() -> [String] {
        if let allContents = try? FileManager.default.contentsOfDirectory(atPath:logDirectory!.path) {
            return allContents
        }
        return []
    }

    func allLogsInDirectory(name: String) -> [String] {
        let logDir = logDirectory!.appendingPathComponent(name).path
        if let allContents = try? FileManager.default.contentsOfDirectory(atPath:logDir) {
            return allContents
        }
        return []
    }

    func logIn(fileName:String) -> String? {
        let fileUrl = currentFolder!.appendingPathComponent(fileName)
        return try? String(contentsOf:fileUrl, encoding: String.Encoding.utf8)
    }

    func appendInConsoleLogFile(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        try? "\(items)".appendToURL(fileURL: currentLogFile!)
    }
}


extension OTDConsolLogger {
    private func getCurrentDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let utcDate = dateFormatter.string(from: date)
        return utcDate
    }

    private func getCurrentTime() -> String {
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

