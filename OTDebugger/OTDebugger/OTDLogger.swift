//
//  OTDLogger.swift
//  OTDebugger
//
//  Created by Sunil Kumar on 02/08/21.
//

import Foundation

class OTDLogger {
    let consoleLogger = OTDConsolLogger()

    public func appendInConsoleLogFile(_ items: Any..., separator: String = " ", terminator: String = "\n", isInclude:Bool = true, logType: OTDLogType) {
        if isInclude {
            switch logType {
            case .console:
                    consoleLogger.appendInConsoleLogFile(items, separator: separator, terminator: terminator)
            case .player:
                print("player log to do")
            }
        }
    }
}
