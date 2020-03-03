//
//  UICollectionViewCell+Identifier.swift
//  AppsList
//
//  Created by Bob De Kort on 28/02/2020.
//  Copyright © 2020 Nodes. All rights reserved.
//

import UIKit

extension UICollectionReusableView {
    static var identifier: String {
        return "\(self)"
    }
}

extension UITableViewCell {
    static var identifier: String {
        return "\(self)"
    }
}
