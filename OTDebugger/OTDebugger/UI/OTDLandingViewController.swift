//
//  OTDebugScreenViewController.swift
//  OTDebugger
//
//  Created by Sunil Kumar on 23/07/21.
//

import UIKit

class OTDLandingViewController: UIViewController {
    var tableView = UITableView()
    var viewModel: OTDLandingViewControllerModel!
    init(viewModel: OTDLandingViewControllerModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    deinit {
        print("deinit: OTDScreenViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAction))
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        setupTableView()
    }

    func setupTableView(){
        tableView.frame = view.frame
        tableView.register(OTDLandingCell.self, forCellReuseIdentifier: "OTDebugCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }

    @objc func doneAction() {
        self.dismiss(animated: false) {
            OTDManager.shared.isDebugViewOpened = false
            OTDManager.shared.dataSource?.dismiss()
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}

extension OTDLandingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.cellModels.count > 0 ? 1 : 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OTDebugCell", for: indexPath) as? OTDLandingCell {
            cell.configureCell(data: viewModel.cellModels[indexPath.row]) { [weak self](isOn, type) in
                if type == .translation {
                    OTDManager.shared.isTranslationKeyEnabled = isOn
                    OTDManager.shared.isDebugViewOpened = false
                    OTDManager.shared.dataSource?.handleTranslationKey(isEnabled: isOn)
                    self?.dismiss(animated: false, completion: nil)
                }
            }
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension OTDLandingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openDetailScreen(cellModel: viewModel.cellModels[indexPath.row])
    }
}

extension OTDLandingViewController {
    func openDetailScreen(cellModel: OTDLandingCellModel) {
        switch cellModel.type {
        case .appInfo:
            if let viewModel = OTDManager.shared.dataSource?.basicInfo() {
                openDetail(detailModel: viewModel)
            } else {
                print("Provide data source for basic info ")
            }
        case .translation:
            print("Switch Action")
        case .uIDebug:
            OTDManager.shared.dataSource?.openFlex()
        case .playerLog:
            if let detailModel = OTDManager.shared.dataSource?.playerLog() {
                openDetail(detailModel: detailModel)
            } else {
                print("Provide data source for basic info ")
            }
        case .consoleLog:
            let logFolders = OTDManager.shared.logger.consoleLogger.allLogDirectory()
            let alert = UIAlertController(title: "Log Folder", message: "Please Select Log Folder", preferredStyle: .actionSheet)
            for folder in logFolders {
                alert.addAction(UIAlertAction(title: folder, style: .default , handler:{(UIAlertAction)in
                    self.processSelectedFolder(folderName: folder)
                }))
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:nil))
            self.present(alert, animated: true, completion: nil)
        case .cmsConfig:
            if let detailModel = OTDManager.shared.dataSource?.cmsConfigLog() {
                openDetail(detailModel: detailModel)
            } else {
                print("Provide data source for basic info ")
            }
        case .translationDiff:
            if let detailModel = OTDManager.shared.dataSource?.translationDiff(), let url = detailModel.url {
                processTranslationFolderUrl(folderUrl: url)
            } else {
                print("Provide data source for basic info ")
            }
        case .clearConsoleLog:
            self.clearConsoleLog()
        case .clearPlayerLog:
            self.clearPlayerLog()
        }
    }

    private func processTranslationFolderUrl(folderUrl:URL) {
        if let allFolders = try? FileManager.default.contentsOfDirectory(atPath:folderUrl.path) {
            let alert = UIAlertController(title: "Translation Folder", message: "Please Select Translation Folder", preferredStyle: .actionSheet)
            for folder in allFolders {
                alert.addAction(UIAlertAction(title: folder, style: .default , handler:{(UIAlertAction)in
                    self.processTranslationContentFolder(folderUrl: folderUrl.appendingPathComponent(folder), translationDirectory: folderUrl)
                }))
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    private func processTranslationContentFolder(folderUrl:URL, translationDirectory: URL) {
        if let allFiles = try? FileManager.default.contentsOfDirectory(atPath:folderUrl.path) {
            let alert = UIAlertController(title: "Translation Files", message: "Please Select Translation Files", preferredStyle: .actionSheet)
            for file in allFiles {
                alert.addAction(UIAlertAction(title: file, style: .default , handler:{(UIAlertAction) in
                    self.processTranslationFile(file: folderUrl.appendingPathComponent(file), translationDirectory: translationDirectory)
                }))
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    private func processTranslationFile(file: URL, translationDirectory: URL) {
        openDetail(title: "Translation", val: "", url: file, zipUrl: translationDirectory)
    }

    private func openDetail(title:String, val:String, url: URL, zipUrl: URL? = nil) {
        let detailModel = OTDDetailViewControllerModel(info: [OTDDetailModel(title: title, value: val)], url: url, zipUrl: zipUrl)
        let view = OTDDetailViewController(viewModel: detailModel)
        let nav = UINavigationController(rootViewController: view)
        nav.modalPresentationStyle = .fullScreen
        nav.delegate = view
        self.present(nav, animated: true, completion: nil)
    }

    private func openDetail(detailModel:OTDDetailViewControllerModel) {
        let view = OTDDetailViewController(viewModel: detailModel)
        let nav = UINavigationController(rootViewController: view)
        nav.modalPresentationStyle = .fullScreen
        nav.delegate = view
        self.present(nav, animated: true, completion: nil)
    }

    private func processSelectedFolder(folderName: String) {
        let logFiles = OTDManager.shared.logger.consoleLogger.allLogsInDirectory(name: folderName)
        let alert = UIAlertController(title: "Log Files", message: "Please Select log file", preferredStyle: .actionSheet)
        for file in logFiles {
            alert.addAction(UIAlertAction(title: file, style: .default , handler:{(UIAlertAction)in
                self.openLogFile(fileName: file)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:nil))
        self.present(alert, animated: true, completion: nil)
    }

    private func openLogFile(fileName: String) {
        let url = OTDManager.shared.logger.consoleLogger.logFilePath(fileName: fileName)
        openDetail(title: "Console Log", val: "", url: url)
    }

    func clearPlayerLog() {

    }

    func clearConsoleLog() {
        //OTDManager.shared.consoleLoger.clearConsoleLog()
    }

}

extension OTDLandingViewController: UINavigationControllerDelegate {
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return .portrait
    }
}

extension OTDLandingViewController {
    class func openDebugScreen() {
        var models = [OTDLandingCellModel]()
        if let infoTypes = OTDManager.shared.infoTypes {
            for type in infoTypes {
                let cellModel = OTDLandingCellModel(type: type, title: type.rawValue)
                models.append(cellModel)
            }
            let debugViewController = OTDLandingViewController(viewModel: OTDLandingViewControllerModel(cellModels: models))
            let nav = UINavigationController(rootViewController: debugViewController)
            nav.modalPresentationStyle = .fullScreen
            nav.delegate = debugViewController
            UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
        }
    }
}
