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
    weak var dataSource: OTDManagerProtocol?
    init(viewModel: OTDScreenViewControllerModel, dataSource: OTDManagerProtocol?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.dataSource = dataSource
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    deinit {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
                self.navigationController?.pushViewController(view, animated: false)
            } else {
                print("Provide data source for basic info ")
            }
        case .translation:
            dataSource?.openFlex()
        case .uIDebug:
            dataSource?.openFlex()
        case .logs:
            print("Player logs")
        }
    }
}
