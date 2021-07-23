//
//  OTDScreenCellModel.swift
//  OTDebugger
//
//  Created by Sunil Kumar on 23/07/21.
//

import Foundation

protocol OTDScreenCellModelProtocol {
    func onTap(_ completion:((_ model: OTDScreenCellModel) -> Void))
}

struct OTDScreenCellModel:OTDScreenCellModelProtocol {
    let title: String
    let type: OTDInfoType
    init(type:OTDInfoType, title: String) {
        self.type = type
        self.title = title
    }

    func onTap(_ completion: ((_ model: OTDScreenCellModel) -> Void)) {

    }
}
