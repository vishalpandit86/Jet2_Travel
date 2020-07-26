//
//  DataStoreProtocol.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 26/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import Foundation

protocol DataStoreProtocol {

    associatedtype T
    func rowsCount(for section:Int) -> Int
    func itemAt(indexPath: IndexPath) -> T?
}
