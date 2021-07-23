//
//  OTDebugManager.swift
//  OTDebugger
//
//  Created by Sunil Kumar on 23/07/21.
//

import Foundation
import UIKit

public enum OTDInfoType: String {
    case basicInfo = "Basic Info"
    case translation = "Translation"
    case uIDebug = "Flex Debug"
}

public class OTDManager {
    let infoTypes: [OTDInfoType]
    public init(infoTypes: [OTDInfoType]) {
        self.infoTypes = infoTypes
    }

    deinit {
       
    }

    public func openDebugScreen(_ viewController:UIViewController) {
        var models = [OTDScreenCellModel]()
        for type in infoTypes {
            let cellModel = OTDScreenCellModel(type: type, title: type.rawValue)
            models.append(cellModel)
        }
        let debug = OTDScreenViewController(viewModel: OTDScreenViewControllerModel(cellModels: models))
        viewController.navigationController?.pushViewController(debug, animated: false)
        print("Welcome")
    }
}
