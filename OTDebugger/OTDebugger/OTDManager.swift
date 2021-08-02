//
//  OTDebugManager.swift
//  OTDebugger
//
//  Created by Sunil Kumar on 23/07/21.
//

import Foundation
import UIKit

public enum OTDInfoType: String {
    case appInfo = "App Info"
    case translation = "Show Translation Key"
    case uIDebug = "Flex Debug"
    case consoleLog = "App console log"
    case clearConsoleLog = "Clear App console log"
    case playerLog = "Player Log"
    case clearPlayerLog = "Clear Player Log"
    case apiLog = "API Log"
}

public protocol OTDManagerProtocol {
    func basicInfo() -> OTDDetailViewControllerModel
    func openFlex(_ enable: Bool)
    func handleTranslationKey(_ enable:Bool)
    func consoleAllLogFolders() -> [String]
    func consoleAllLogFilesIn(_ folder: String) -> [String]
    func consoleLogIn(_ file: String) -> String
    func playerLog() -> String
    func dismiss()
}

final public class OTDManager {
    static public let shared = OTDManager()
    private let bufferSize = 50
    private init() {
    }
    var infoTypes: [OTDInfoType]?
    var dataSource: OTDManagerProtocol?
    var consoleLoger = OTDConsolLogger()
    var bufferLog = [Any]()
    public func configure(infoTypes: [OTDInfoType], dataSource:OTDManagerProtocol?) {
        self.infoTypes = infoTypes
        self.dataSource = dataSource
    }
    public func openDebugScreen() {
        OTDScreenViewController.openDebugScreen()
    }

    public func appendInConsoleLogFile(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        DispatchQueue(label: "Serail Queue").async {
            self.bufferLog.append(items)
            if self.bufferLog.count >= self.bufferSize {
                let logs = self.bufferLog.reduce("") { (interimResult, item) -> String in
                    return "\(interimResult)" + "\(item)"
                }
                self.consoleLoger.appendInConsoleLogFile(logs)
                self.bufferLog.removeAll()
            }
        }
    }
}
