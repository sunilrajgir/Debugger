//
//  OTDInfoViewController.swift
//  OTDebugger
//
//  Created by Sunil Kumar on 23/07/21.
//

import UIKit

public struct OTDInfoViewControllerModel {
    let info : [OTDinfoModel]
    public init(info:[OTDinfoModel]) {
        self.info = info
    }
}

public struct OTDinfoModel {
    let title: String
    let value: String
    public init(title:String, value: String) {
        self.title = title
        self.value = value
    }
}

class OTDInfoViewController: UIViewController {
    var viewModel: OTDInfoViewControllerModel!
    var textView = UITextView()

    init(viewModel: OTDInfoViewControllerModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        textView.frame = self.view.frame
        view.addSubview(textView)
        bindData()
    }

    func bindData() {
        let attributeString = NSMutableAttributedString()
        for data in viewModel.info {
            let title = NSMutableAttributedString(string: "\(data.title): ")
            title.addAttribute(.foregroundColor, value: UIColor.black, range: NSMakeRange(0, title.length))
            title.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .bold), range: NSMakeRange(0, title.length))
            let value = NSMutableAttributedString(string: "\(data.value) \n\n")
            value.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSMakeRange(0, value.length))
            value.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .medium), range: NSMakeRange(0, value.length))
            title.append(value)
            attributeString.append(title)
        }
        textView.attributedText = attributeString
    }
}
