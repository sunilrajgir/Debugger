//
//  OTDInfoViewController.swift
//  OTDebugger
//
//  Created by Sunil Kumar on 23/07/21.
//

import UIKit

enum ODTInfo: String {
    case version = "App Version"
    case language = "Language"
    case environment = "Environment"
}

class OTDInfoViewController: UIViewController {
    var textView = UITextView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        textView.frame = self.view.frame
        view.addSubview(textView)
        bindData()
    }

    func bindData() {
        let attributeString = NSMutableAttributedString()
        attributeString.append(version())

        textView.attributedText = attributeString
    }

    func version() -> NSAttributedString {
        let version = NSMutableAttributedString(string: "\(ODTInfo.version.rawValue): ")
        version.addAttribute(.foregroundColor, value: UIColor.black, range: NSMakeRange(0, version.length))
        version.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .bold), range: NSMakeRange(0, version.length))
        let versionValue = NSMutableAttributedString(string: "3.8.0 \n")
        versionValue.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSMakeRange(0, versionValue.length))
        versionValue.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .medium), range: NSMakeRange(0, versionValue.length))
        version.append(versionValue)
        return version
    }

}
