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
    var dataSource: OTDManagerProtocol?
    init(viewModel: OTDScreenViewControllerModel, dataSource: OTDManagerProtocol?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.dataSource = dataSource
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
            self.dataSource?.dismiss()
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
                    self.dataSource?.handleTranslationKey(isOn)
                } else if type == .uIDebug {
                    self.dataSource?.openFlex(isOn)
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
            if let viewModel = dataSource?.basicInfo() {
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
            if let log = dataSource?.playerLog() {
                let view = OTDInfoViewController(viewModel: OTDInfoViewControllerModel(info: [OTDinfoModel(title: "Console Log", value: log)]))
                self.present(view, animated: true, completion: nil)
            } else {
                print("Provide data source for basic info ")
            }
        case .apiLog:
            print("api logs")
        case .consoleLog:
            if let logFolders = dataSource?.consoleAllLogFolders() {
                let alert = UIAlertController(title: "Log Folder", message: "Please Select Log Folder", preferredStyle: .actionSheet)
                for folder in logFolders {
                    alert.addAction(UIAlertAction(title: folder, style: .default , handler:{(UIAlertAction)in
                        self.processSelectedFolder(folderName: folder)
                    }))
                }

                self.present(alert, animated: true, completion: nil)
            } else {
                print("Provide data source for basic info ")
            }
        case .clearConsoleLog:
            print("Provide data source for basic info ")
        case .clearPlayerLog:
            print("Provide data source for basic info ")
        }
    }

    func processSelectedFolder(folderName: String) {
        if let logFiles = dataSource?.consoleAllLogFilesIn(folderName) {
            let alert = UIAlertController(title: "Log Files", message: "Please Select log file", preferredStyle: .actionSheet)
            for file in logFiles {
                alert.addAction(UIAlertAction(title: file, style: .default , handler:{(UIAlertAction)in
                    self.openLogFile(fileName: file)
                }))
            }
            self.present(alert, animated: true, completion: nil)
        }
    }

    func openLogFile(fileName: String) {
        if let log = dataSource?.consoleLogIn(fileName) {
            let view = OTDInfoViewController(viewModel: OTDInfoViewControllerModel(info: [OTDinfoModel(title: "Console Log", value: log)]))
            let nav = UINavigationController(rootViewController: view)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
}
