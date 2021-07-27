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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAction))
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
            print("Player logs")
        case .apiLog:
            print("api logs")
        case .consoleLog:
            print("console logs")
        }
    }
}
