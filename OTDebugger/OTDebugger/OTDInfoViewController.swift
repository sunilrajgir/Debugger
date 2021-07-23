//
//  OTDInfoViewController.swift
//  OTDebugger
//
//  Created by Sunil Kumar on 23/07/21.
//

import UIKit

enum ODTInfo: String {
    case version = "version"
    case language = "Language"
    case environment = "Environment"
}

class OTDInfoViewController: UIViewController {
    var stackVew = UIStackView()
    var info = [String:String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        info[ODTInfo.version.rawValue] = "3.8.0"
        info[ODTInfo.language.rawValue] = "English"
        info[ODTInfo.environment.rawValue] = "Environment"
    }

    func setupStackView() {
        stackVew.frame = CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.height)
    }

}
