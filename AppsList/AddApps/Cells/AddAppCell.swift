//
//  AddAppCell.swift
//  AppsList
//
//  Created by Bob De Kort on 28/02/2020.
//  Copyright © 2020 Nodes. All rights reserved.
//

import UIKit

protocol AddAppCellDelegate {
    func addPressed(indexPath: IndexPath)
}

class AddAppCell: UITableViewCell {

    // MARK: - IBOutlets -
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    // MARK: - Properties -
    private var indexPath: IndexPath?
    private var app: App?
    var delegate: AddAppCellDelegate?
    
    // MARK: - Life cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
//        populate()
    }
    
    private func populate() {
        if let app = app {
            iconImageView?.image = UIImage(named: "temple")
            nameLabel?.text = app.name
        }
    }
    
    // MARK: - Callbacks -
    @IBAction func addPressed(_ sender: Any) {
        if let indexPath = indexPath {
            delegate?.addPressed(indexPath: indexPath)
        }
    }
    
    // MARK: - Configuration -
    func configure(with app: App, indexPath: IndexPath) {
        self.indexPath = indexPath
        self.app = app
        populate()
    }
}
