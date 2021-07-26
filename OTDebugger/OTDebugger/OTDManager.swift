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
    case enableTranslationKey = "Show Translation Key"
    case disableTranslationKey = "Hide Translation Key"
    case uIDebug = "Flex Debug"
    case playerLog = "Player Log"
    case apiLog = "API Log"
    case consoleLog = "App console log"
}

public protocol OTDManagerProtocol {
    func basicInfo() -> OTDInfoViewControllerModel
    func openFlex()
    func handleTranslationKey(_ enable:Bool)
}

public class OTDManager {
    let infoTypes: [OTDInfoType]
    var dataSource: OTDManagerProtocol?
    public init(infoTypes: [OTDInfoType], dataSource:OTDManagerProtocol?) {
        self.infoTypes = infoTypes
        self.dataSource = dataSource
    }
    deinit {
        print("deinit: OTDManager")
    }
    public func openDebugScreen(_ viewController:UIViewController) {
        var models = [OTDScreenCellModel]()
        for type in infoTypes {
            let cellModel = OTDScreenCellModel(type: type, title: type.rawValue)
            models.append(cellModel)
        }
        let debug = OTDScreenViewController(viewModel: OTDScreenViewControllerModel(cellModels: models),dataSource: dataSource)
        UIApplication.shared.keyWindow?.rootViewController?.present(debug, animated: true, completion: nil)
    }
}
