//
//  OTDebugScreenViewController.swift
//  OTDebugger
//
//  Created by Sunil Kumar on 23/07/21.
//

import UIKit

class OTDScreenViewController: UIViewController {
    var tableView = UITableView()
    var viewModel: OTDScreenViewControllerModel!
    init(viewModel: OTDScreenViewControllerModel) {
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
        setupTableView()
    }

    func setupTableView(){
        tableView.frame = view.frame
        tableView.register(OTDebugCell.self, forCellReuseIdentifier: "OTDebugCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }

    @objc func doneAction() {
        self.dismiss(animated: false) {
            OTDManager.shared.dataSource?.dismiss()
        }
    }
}

extension OTDScreenViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.cellModels.count > 0 ? 1 : 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OTDebugCell", for: indexPath) as? OTDebugCell {
            cell.configureCell(data: viewModel.cellModels[indexPath.row])
            cell.onSwitchAction =  {(isOn,type) in
                if type == .translation {
                    OTDManager.shared.dataSource?.handleTranslationKey(isOn)
                } else if type == .uIDebug {
                    OTDManager.shared.dataSource?.openFlex(isOn)
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

extension OTDScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        viewModel.cellModels[indexPath.row].onTap { (model) in
//        }
        openDetailScreen(cellModel: viewModel.cellModels[indexPath.row])
    }
}

extension OTDScreenViewController {
    func openDetailScreen(cellModel: OTDScreenCellModel) {
        switch cellModel.type {
        case .appInfo:
            if let viewModel = OTDManager.shared.dataSource?.basicInfo() {
                let view = OTDInfoViewController(viewModel: viewModel)
                self.present(view, animated: true, completion: nil)
            } else {
                print("Provide data source for basic info ")
            }
        case .translation:
            print("Switch Action")
        case .uIDebug:
            print("Switch Action")
        case .playerLog:
            if let log = OTDManager.shared.dataSource?.playerLog() {
                let view = OTDInfoViewController(viewModel: OTDInfoViewControllerModel(info: [OTDinfoModel(title: "Console Log", value: log)]))
                self.present(view, animated: true, completion: nil)
            } else {
                print("Provide data source for basic info ")
            }
        case .apiLog:
            print("api logs")
        case .consoleLog:
            let logFolders = OTDManager.shared.consoleLoger.allLogDirectory()
            let alert = UIAlertController(title: "Log Folder", message: "Please Select Log Folder", preferredStyle: .actionSheet)
            for folder in logFolders {
                alert.addAction(UIAlertAction(title: folder, style: .default , handler:{(UIAlertAction)in
                    self.processSelectedFolder(folderName: folder)
                }))
            }
            self.present(alert, animated: true, completion: nil)
        case .clearConsoleLog:
            print("Provide data source for basic info ")
        case .clearPlayerLog:
            print("Provide data source for basic info ")
        }
    }

    func processSelectedFolder(folderName: String) {
        let logFiles = OTDManager.shared.consoleLoger.allLogsInDirectory(name: folderName)
        let alert = UIAlertController(title: "Log Files", message: "Please Select log file", preferredStyle: .actionSheet)
        for file in logFiles {
            alert.addAction(UIAlertAction(title: file, style: .default , handler:{(UIAlertAction)in
                self.openLogFile(fileName: file)
            }))
        }
        self.present(alert, animated: true, completion: nil)
    }

    func openLogFile(fileName: String) {
        if let log = OTDManager.shared.consoleLoger.logIn(fileName: fileName) {
            let view = OTDInfoViewController(viewModel: OTDInfoViewControllerModel(info: [OTDinfoModel(title: "Console Log", value: log)]))
            view.logFileName = fileName
            let nav = UINavigationController(rootViewController: view)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
}

extension OTDScreenViewController {
    class func openDebugScreen() {
        var models = [OTDScreenCellModel]()
        if let infoTypes = OTDManager.shared.infoTypes {
            for type in infoTypes {
                let cellModel = OTDScreenCellModel(type: type, title: type.rawValue)
                models.append(cellModel)
            }
            let debugViewController = OTDScreenViewController(viewModel: OTDScreenViewControllerModel(cellModels: models))
            let nav = UINavigationController(rootViewController: debugViewController)
            nav.modalPresentationStyle = .fullScreen
            UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
        }
    }
}
