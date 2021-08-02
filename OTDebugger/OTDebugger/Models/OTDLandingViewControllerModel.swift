//
//  OTDScreenViewControllerModel.swift
//  OTDebugger
//
//  Created by Sunil Kumar on 23/07/21.
//

import Foundation

struct OTDLandingViewControllerModel {
    let cellModels: [OTDLandingCellModel]
    init(cellModels: [OTDLandingCellModel]) {
        self.cellModels = cellModels
    }
}
