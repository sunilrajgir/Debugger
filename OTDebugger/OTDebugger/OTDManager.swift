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
    case translation = "Translation Keys"
    case uIDebug = "Flex Debug"
    case logs = "Logs"
}

public protocol OTDManagerProtocol: NSObject {
    func basicInfo() -> OTDInfoViewControllerModel
    func openFlex()
}

public class OTDManager {
    let infoTypes: [OTDInfoType]
    weak var dataSource: OTDManagerProtocol?
    public init(infoTypes: [OTDInfoType], dataSource:OTDManagerProtocol?) {
        self.infoTypes = infoTypes
        self.dataSource = dataSource
    }
    public func openDebugScreen(_ viewController:UIViewController) {
        var models = [OTDScreenCellModel]()
        for type in infoTypes {
            let cellModel = OTDScreenCellModel(type: type, title: type.rawValue)
            models.append(cellModel)
        }
        let debug = OTDScreenViewController(viewModel: OTDScreenViewControllerModel(cellModels: models),dataSource: dataSource)
        viewController.navigationController?.pushViewController(debug, animated: false)
    }
}
