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
}

public protocol OTDManagerProtocol {
    func basicInfo() -> OTDDetailViewControllerModel
    func openFlex()
    func playerLog() -> String
    func dismiss()
}

final public class OTDManager {
    static public let shared = OTDManager()
    var infoTypes: [OTDInfoType]?
    var dataSource: OTDManagerProtocol?
    var consoleLoger = OTDConsolLogger()
    public let bufferSize = 1
    var bufferLog = [Any]()
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

    public func appendInConsoleLogFile(_ items: Any..., separator: String = " ", terminator: String = "\n", isInclude:Bool = true) {
        guard isInclude else {
            return
        }
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
