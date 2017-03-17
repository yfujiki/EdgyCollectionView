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

    func cell(_ cell: UICollectionViewCell, didStartLongPressAt position: CGPoint)
    func cell(_ cell: UICollectionViewCell, didUpdateLongPressAt position: CGPoint)
    func cell(_ cell: UICollectionViewCell, didEndLongPressAt position: CGPoint)
    func cell(_ cell: UICollectionViewCell, didCancelLongPressAt position: CGPoint)
}

class PhotoCell: UICollectionViewCell {

    private var baseName: String?
    private var cellMode: CellMode = .photo

    private lazy var pinchGestureRecognizer: UIPinchGestureRecognizer = {
        let gestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(PhotoCell.pinched))
        return gestureRecognizer
    }()

    private lazy var longPressGestureRecognizer: UILongPressGestureRecognizer = {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(PhotoCell.longPressed))
        gestureRecognizer.minimumPressDuration = 0.2
        return gestureRecognizer
    }()

    @IBOutlet weak var imageView: UIImageView!

    weak var delegate: PhotoCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.addGestureRecognizer(pinchGestureRecognizer)
        self.addGestureRecognizer(longPressGestureRecognizer)
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

    func longPressed(gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: self)

        switch gestureRecognizer.state {
        case .began:
            delegate?.cell(self, didStartLongPressAt: location)
        case .changed:
            delegate?.cell(self, didUpdateLongPressAt: location)
        case .ended:
            delegate?.cell(self, didEndLongPressAt: location)
        case .cancelled, .failed:
            delegate?.cell(self, didCancelLongPressAt: location)
        case .possible:
            break   // do nothing
        }
    }
}
