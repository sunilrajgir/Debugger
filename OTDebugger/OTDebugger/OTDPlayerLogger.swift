//
//  OTDPlayerLogger.swift
//  OTDebugger
//
//  Created by Sunil Kumar on 02/08/21.
//

import Foundation


class OTDPlayerLogger {
    var logDirectory: URL?
    var currentFolder: URL?
    var currentLogFile: URL?
    private var logs = ""

    init(){
        setupLogFolder()
    }

    private func setupLogFolder() {
        createLogDirectory()
        createFolder()
        createCurrentLogFile()
    }

    private func createLogDirectory() {
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        logDirectory = dirPaths[0].appendingPathComponent("OTPlayerLogs")
    }

    private func createFolder() {
        var docsURL = logDirectory
        let currentDate = Utility.getCurrentDate()
        docsURL?.appendPathComponent(currentDate)
        if FileManager.default.fileExists(atPath: docsURL!.path) {
            currentFolder = docsURL
        } else {
            try? FileManager.default.createDirectory(at: docsURL!, withIntermediateDirectories: true, attributes: nil)
            currentFolder = docsURL
        }
    }

    private func createCurrentLogFile() {
        let currentTime = Utility.getCurrentTime()
        let url = currentFolder?.appendingPathComponent("\(currentTime).txt")
        currentLogFile = url
        try? "\(Date())".appendToURL(fileURL: currentLogFile!)
    }

    public func getCurrentLogFile() -> URL? {
        return currentLogFile
    }

    func allLogDirectory() -> [String] {
        if let path = logDirectory?.path,  let allContents = try? FileManager.default.contentsOfDirectory(atPath:path) {
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

    func clearConsoleLog() {
        if let path = logDirectory?.path {
            try? FileManager.default.removeItem(atPath: path)
        }
        logDirectory = nil
    }

    func logFilePath(fileName:String) -> URL {
        return currentFolder!.appendingPathComponent(fileName)
    }

    func appendInConsoleLogFile(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        if logDirectory == nil {
            setupLogFolder()
        }
        try? "\(items)".appendToURL(fileURL: currentLogFile!)
    }
}
