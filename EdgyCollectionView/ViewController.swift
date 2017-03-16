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
        ("NewYork", .photo),
        ("Texas", .photo),
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
            return CGSize(width: collectionView.bounds.width / 2, height: collectionView.bounds.width * 3 / 8)
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

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCell
        cell.setBaseName(baseName)

        return cell
    }

}
