//
//  DataSource.swift
//  EdgyCollectionView
//
//  Created by Alex Du Bois on 3/28/17.
//  Copyright © 2017 yfujiki. All rights reserved.
//

import Foundation

class DataSource {

    public static var shared = DataSource()

    public var baseData: [(String, CellMode, Visibility)] = [
        ("NewYork", .photo, true),
        ("Texas", .photo, true),
        ("Illinois", .photo, true),
        ("Montana", .photo, true),
        ("California", .photo, true),
        ("Oregon", .photo, true),
        ("Florida", .photo, true)
    ]

    public var virtualBaseData: [(String, CellMode, Visibility)]!

    private init() { }
}
