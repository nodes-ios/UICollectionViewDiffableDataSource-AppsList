//
//  App.swift
//  AppsList
//
//  Created by Bob De Kort on 28/02/2020.
//  Copyright © 2020 Nodes. All rights reserved.
//

import Foundation

struct App: Decodable, Hashable {
    let id: Int
    let name: String
    let image: String
}
