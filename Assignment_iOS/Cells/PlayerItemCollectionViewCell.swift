//
//  PlayerItemCollectionViewCell.swift
//  Assignment_iOS
//
//  Created by Mohammad Dijoo on 12/10/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import UIKit
import AVKit

class PlayerItemCollectionViewCell: UICollectionViewCell {

    //MARK: - Variables and Constants
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func prepareForReuse() {
        playerLayer?.removeFromSuperlayer()
    }
    
    //MARK: - Create AVPlayer and assign url
    func setData(url: String?) {
        if let videoURL = URL(string: url ?? "") {
            player = AVPlayer(url: videoURL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = self.bounds
            playerLayer?.videoGravity = AVLayerVideoGravity.resize
            
            if let playerLayer = self.playerLayer {
                self.layer.addSublayer(playerLayer)
            }
        }
    }

}
