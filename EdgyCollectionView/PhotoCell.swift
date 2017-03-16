//
//  PhotoCell.swift
//  EdgyCollectionView
//
//  Created by Yuichi Fujiki on 3/16/17.
//  Copyright © 2017 yfujiki. All rights reserved.
//

import UIKit

protocol PhotoCellDelegate: class {
    func cell(_ cell: UICollectionViewCell, modeChangedTo cellMode: CellMode)

    func didStartLongPress(at position: CGPoint)
    func didUpdateLongPress(at position: CGPoint)
    func didEndLongPress(at position: CGPoint)
    func didCancelLongPress(at position: CGPoint)
}

class PhotoCell: UICollectionViewCell {

    private var baseName: String?
    private var cellMode: CellMode = .photo

    private lazy var pinchGestureRecognizer: UIPinchGestureRecognizer = {
        let gestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(PhotoCell.pinched))
        return gestureRecognizer
    }()

    @IBOutlet weak var imageView: UIImageView!

    weak var delegate: PhotoCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.addGestureRecognizer(pinchGestureRecognizer)
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

    func pinched(gestureRecognizer: UIPinchGestureRecognizer) {
        if gestureRecognizer.scale > 1 && cellMode == .logo {
            // Expand
            setCellMode(.photo)
            delegate?.cell(self, modeChangedTo: .photo)
        } else if gestureRecognizer.scale < 1 && cellMode == .photo{
            // Shrink
            setCellMode(.logo)
            delegate?.cell(self, modeChangedTo: .logo)
        }
    }
}
