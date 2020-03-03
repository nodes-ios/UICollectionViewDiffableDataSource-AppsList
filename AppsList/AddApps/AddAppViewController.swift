//
//  AddAppViewController.swift
//  AppsList
//
//  Created by Bob De Kort on 28/02/2020.
//  Copyright © 2020 Nodes. All rights reserved.
//

import UIKit

protocol AddAppViewControllerDelegate {
    func add(_ app: App)
}

class AddAppViewController: UIViewController {
    // MARK: - IBOutlets -
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    var delegate: AddAppViewControllerDelegate?
    var dataSource: [App] = []
    
    // MARK: - Life cycle -
    class func instantiate(with dataSource: [App]) -> AddAppViewController {
        let name = "\(AddAppViewController.self)"
        let storyboard = UIStoryboard(name: name, bundle: nil)
        // swiftlint:disable:next force_cast
        let vc = storyboard.instantiateViewController(withIdentifier: name) as! AddAppViewController
        vc.dataSource = dataSource
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: - Setup methods -
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
}

extension AddAppViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddAppCell.identifier, for: indexPath) as? AddAppCell else {
            fatalError("Could not dequeue AddAppCell")
        }
        
        let app = dataSource[indexPath.row]
        cell.configure(with: app, indexPath: indexPath)
        cell.delegate = self
        
        return cell
    }
}

extension AddAppViewController: AddAppCellDelegate {
    func addPressed(indexPath: IndexPath) {
        let app = dataSource[indexPath.row]
        dismiss(animated: true) {
            self.delegate?.add(app)
        }
    }
}
