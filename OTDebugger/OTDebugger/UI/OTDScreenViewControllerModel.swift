//
//  OTDScreenViewControllerModel.swift
//  OTDebugger
//
//  Created by Sunil Kumar on 23/07/21.
//

import Foundation

struct OTDScreenViewControllerModel {
    let cellModels: [OTDScreenCellModel]
    init(cellModels: [OTDScreenCellModel]) {
        self.cellModels = cellModels
    }
}
