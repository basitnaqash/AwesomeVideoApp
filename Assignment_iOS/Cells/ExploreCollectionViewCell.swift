//
//  ExploreCollectionViewCell.swift
//  Assignment_iOS
//
//  Created by Mohammad Dijoo on 12/10/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import UIKit
import AVFoundation

class ExploreCollectionViewCell: UICollectionViewCell {

    //MARK: - IBoutlets
    @IBOutlet weak var imageView: UIImageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = imageView.bounds.width / 15
    }
}
