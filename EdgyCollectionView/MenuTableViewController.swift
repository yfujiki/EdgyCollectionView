//
//  MenuTableViewController.swift
//  EdgyCollectionView
//
//  Created by Alex Du Bois on 3/27/17.
//  Copyright © 2017 yfujiki. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    fileprivate var sectionTitles: [String] = [
        "Visible",
        "Not Visible"
    ]

    fileprivate var baseData: [String: Bool] = [
        "NewYork": true,
        "Texas": true,
        "Illinois": true,
        "Montana": true,
        "California": true,
        "Oregon": true,
        "Florida": true
    ]

    fileprivate var visibleCells: [String: Bool] {
        let cells = baseData.filter { $0.value == true }
        var visibleCells = [String: Bool]()
        for cell in cells {
            visibleCells[cell.key] = cell.value
        }

        return visibleCells
    }

    fileprivate var invisibleCells: [String: Bool] {
        let cells = baseData.filter { $0.value == false }
        var visibleCells = [String: Bool]()
        for cell in cells {
            visibleCells[cell.key] = cell.value
        }

        return visibleCells
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return baseData.filter { $0.value == true }.count
        } else {
            return baseData.filter { $0.value == false }.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        switch indexPath.section {
        case 0: cell.textLabel?.text = Array(visibleCells.keys)[indexPath.row]
        case 1: cell.textLabel?.text = Array(invisibleCells.keys)[indexPath.row]
        default: break
        }

        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        guard let key = cell?.textLabel?.text,
            let isVisible = baseData[key] else {
            return tableView.deselectRow(at: indexPath, animated: false)
        }

        baseData[key] = !isVisible

        var newPath = indexPath
        newPath.section = !isVisible ? 0 : 1

        tableView.moveRow(at: indexPath, to: newPath)
    }

    
}
