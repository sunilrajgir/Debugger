//
//  OTDInfoViewController.swift
//  OTDebugger
//
//  Created by Sunil Kumar on 23/07/21.
//

import UIKit

public struct OTDDetailViewControllerModel {
    let info: [OTDDetailModel]
    let url: URL?
    let zipUrl: URL? 
    public init(info: [OTDDetailModel], url: URL?, zipUrl: URL? = nil) {
        self.info = info
        self.url = url
        self.zipUrl = zipUrl
    }
}

public struct OTDDetailModel {
    let title: String
    let value: String
    public init(title:String, value: String) {
        self.title = title
        self.value = value
    }
}

class OTDDetailViewController: UIViewController {
    private var viewModel: OTDDetailViewControllerModel!
    private var textView = UITextView()

    init(viewModel: OTDDetailViewControllerModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationButtons()
        self.view.backgroundColor = .white
        textView.frame = self.view.frame
        view.addSubview(textView)
        bindData()
    }

    private func addNavigationButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareAction))
    }

    private func bindData() {
        let attributeString = NSMutableAttributedString()
        if let fileUrl = viewModel.url {
            if let val = try? String(contentsOf:fileUrl, encoding: String.Encoding.utf8) {
                attributeString.append(transformData(title: fileUrl.path, value: val))
            } else {
                attributeString.append(transformData(title: fileUrl.path, value: "No content found"))
            }
        } else {
            for data in viewModel.info {
                attributeString.append(transformData(title: data.title, value: data.value))
            }
        }
        textView.attributedText = attributeString
    }

    private func transformData(title: String, value: String) -> NSAttributedString {
        let title = NSMutableAttributedString(string: "\(title): ")
        title.addAttribute(.foregroundColor, value: UIColor.black, range: NSMakeRange(0, title.length))
        title.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .bold), range: NSMakeRange(0, title.length))
        let value = NSMutableAttributedString(string: "\(value) \n\n")
        value.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSMakeRange(0, value.length))
        value.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .medium), range: NSMakeRange(0, value.length))
        title.append(value)
        return title
    }

    @objc func doneAction() {
        self.dismiss(animated: false) {
        }
    }

    @objc func shareAction() {
        let items: [Any]
        var deleteZipUrl: URL?
        if let url = viewModel.zipUrl, let zipUrl = zipContent(url: url) {
            deleteZipUrl = zipUrl
            items = [zipUrl]
        }else if let fileUrl = viewModel.url {
            items = [fileUrl]
        } else {
            items = [textView.text as Any]
        }
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
            if deleteZipUrl != nil {
                try? FileManager.default.removeItem(at: deleteZipUrl!)
            }
         }
        self.present(activityViewController, animated: true)
    }

    func zipContent(url: URL) -> URL? {
        let coordinator = NSFileCoordinator()
        var error: NSError?
        let tempUrl = url.appendingPathComponent("TranslationShareArchive.zip")
        coordinator.coordinate(readingItemAt: url, options: [.forUploading], error: &error) { (contentUrl) in
            try? FileManager.default.copyItem(at: contentUrl, to: tempUrl)
        }
        return tempUrl
    }
}

extension OTDDetailViewController: UINavigationControllerDelegate {
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return .portrait
    }
}

