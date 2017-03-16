//
//  ViewController.swift
//  EdgyCollectionView
//
//  Created by Yuichi Fujiki on 3/16/17.
//  Copyright © 2017 yfujiki. All rights reserved.
//

import UIKit

enum CellMode {
    case logo
    case photo
}

class ViewController: UIViewController {

    fileprivate var baseData: [(String, CellMode)] = [
        ("NewYork", .logo),
        ("Texas", .logo),
        ("Illinois", .photo),
        ("Montana", .photo),
        ("California", .photo),
        ("Oregon", .photo),
        ("Florida", .photo)
    ]

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let baseName = baseData[indexPath.item].0
        let cellMode = baseData[indexPath.item].1

        switch  cellMode {
        case .logo:
            let width = collectionView.bounds.width / 2 - collectionView.layoutMargins.left - collectionView.layoutMargins.right
            let height = width * 3 / 8
            return CGSize(width: width, height: height)
        default: // photo
            let photo = UIImage(named: "\(baseName)_Photo")!
            let width = collectionView.bounds.width
            let height = photo.size.height / photo.size.width * width // keep proportion
            return CGSize(width: width, height: height)
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return baseData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let baseName = baseData[indexPath.item].0
        let cellMode = baseData[indexPath.item].1

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCell
        cell.setCellMode(cellMode)
        cell.setBaseName(baseName)
        cell.delegate = self

        return cell
    }
}

extension ViewController: PhotoCellDelegate {
    func cell(_ cell: UICollectionViewCell, modeChangedTo cellMode: CellMode) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }

        baseData[indexPath.item].1 = cellMode

        collectionView.reloadItems(at: [indexPath])
    }

    func didStartLongPress(at position: CGPoint) {
    }

    func didUpdateLongPress(at position: CGPoint) {
    }

    func didEndLongPress(at position: CGPoint) {
    }

    func didCancelLongPress(at position: CGPoint) {
    }
}
