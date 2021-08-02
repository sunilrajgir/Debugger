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
    case cmsConfig = "CMS Config"
    case translationDiff = "Translation Diff"
    case clearConsoleLog = "Clear App console log"
    case playerLog = "Player Log"
    case clearPlayerLog = "Clear Player Log"
}

public enum OTDLogType: String {
    case console = "Console Log"
    case player = "Player Log"
}

public protocol OTDManagerProtocol {
    func basicInfo() -> OTDDetailViewControllerModel
    func openFlex()
    func playerLog() -> String
    func cmsConfigLog() -> String
    func translationDiff() -> String
    func dismiss()
}

final public class OTDManager {
    static public let shared = OTDManager()
    var infoTypes: [OTDInfoType]?
    var dataSource: OTDManagerProtocol?
    let logger = OTDLogger()
    public var isDebugViewOpened = false
    public var isTranslationKeyEnabled = false

    private init() {
    }

    public func configure(infoTypes: [OTDInfoType], dataSource:OTDManagerProtocol?) {
        self.infoTypes = infoTypes
        self.dataSource = dataSource
    }
    public func openDebugScreen() {
        if !isDebugViewOpened {
            isDebugViewOpened = true
            OTDScreenViewController.openDebugScreen()
        }
    }

    public func appendInConsoleLogFile(_ items: Any..., separator: String = " ", terminator: String = "\n", isInclude:Bool = true, logType: OTDLogType) {
        logger.appendInConsoleLogFile(items, separator: separator, terminator: terminator, isInclude: isInclude, logType: logType)
    }
}
