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
    func basicInfo() -> OTDInfoViewControllerModel
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
    private init() {
    }
    var infoTypes: [OTDInfoType]?
    var dataSource: OTDManagerProtocol?
    var consoleLoger = OTDConsolLogger()
    public func configure(infoTypes: [OTDInfoType], dataSource:OTDManagerProtocol?) {
        self.infoTypes = infoTypes
        self.dataSource = dataSource
    }
    public func openDebugScreen() {
        OTDScreenViewController.openDebugScreen()
    }

    public func appendInConsoleLogFile(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        self.consoleLoger.appendInConsoleLogFile(items, separator: separator, terminator: terminator)
    }
}
