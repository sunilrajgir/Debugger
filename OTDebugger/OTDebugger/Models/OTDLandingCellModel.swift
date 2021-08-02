//
//  OTDScreenCellModel.swift
//  OTDebugger
//
//  Created by Sunil Kumar on 23/07/21.
//

import Foundation

protocol OTDScreenCellModelProtocol {
    func onTap(_ completion:((_ model: OTDLandingCellModel) -> Void))
}

struct OTDLandingCellModel:OTDScreenCellModelProtocol {
    let title: String
    let type: OTDLandingCellType
    init(type:OTDLandingCellType, title: String) {
        self.type = type
        self.title = title
    }

    func onTap(_ completion: ((_ model: OTDLandingCellModel) -> Void)) {

    }
}
