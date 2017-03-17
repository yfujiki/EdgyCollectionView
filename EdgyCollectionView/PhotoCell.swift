//
//  PhotoCell.swift
//  EdgyCollectionView
//
//  Created by Yuichi Fujiki on 3/16/17.
//  Copyright © 2017 yfujiki. All rights reserved.
//

import UIKit

protocol PhotoCellDelegate: class {
    func didStartZoomInForCell(_ cell: UICollectionViewCell)
    func didStartZoomOutForCell(_ cell: UICollectionViewCell)

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
        let pinchScale = gestureRecognizer.scale

        switch gestureRecognizer.state {
        case .ended, .cancelled:
            self.transform = CGAffineTransform.identity
            return
        default:
            break
        }

        if pinchScale > 1 && cellMode == .logo {
            if gestureRecognizer.state == .began {
                delegate?.didStartZoomInForCell(self)
            }
            if pinchScale > 2 {
                self.transform = CGAffineTransform.identity
                // Expand
                setCellMode(.photo)
                delegate?.cell(self, modeChangedTo: .photo)
            } else {
                self.transform = CGAffineTransform(scaleX: pinchScale, y: pinchScale)
            }
        } else if pinchScale < 1 && cellMode == .photo {
            if gestureRecognizer.state == .began {
                delegate?.didStartZoomOutForCell(self)
            }
            if pinchScale < 0.6 {
                self.transform = CGAffineTransform.identity
                // Shrink
                setCellMode(.logo)
                delegate?.cell(self, modeChangedTo: .logo)
            } else {
                self.transform = CGAffineTransform(scaleX: pinchScale, y: pinchScale)
            }
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
