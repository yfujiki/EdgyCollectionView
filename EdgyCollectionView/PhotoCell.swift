//
//  PhotoCell.swift
//  EdgyCollectionView
//
//  Created by Yuichi Fujiki on 3/16/17.
//  Copyright © 2017 yfujiki. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {

    private var baseName: String?
    private var cellMode: CellMode = .photo

    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setCellMode(_ cellMode: CellMode) {
        self.cellMode = cellMode
        if let name = baseName {
            setBaseName(name)
        }
    }

    func setBaseName(_ name: String) {
        baseName = name

        switch cellMode {
        case .logo:
            imageView.image = UIImage(named: "\(name)_Logo")
        default:
            imageView.image = UIImage(named: "\(name)_Photo")
        }
    }
}
