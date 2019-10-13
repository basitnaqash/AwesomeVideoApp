//
//  ExploreTableViewCell.swift
//  Assignment_iOS
//
//  Created by Mohammad Dijoo on 12/10/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import UIKit
import AVKit

protocol ItemSelectedDelegate {
    func onItemSelected(sectionIndex: Int, videoIndex: Int)
}

class ExploreTableViewCell: UITableViewCell {
    
    //MARK: - IBoutlets
    @IBOutlet weak var collectionView: UICollectionView!
    var delegate: ItemSelectedDelegate?
    
    //MARK: - Variables and constants
    let cellReuseIdentifier = "ExploreCollectionViewCell"
    var videos: [VideoModel]?
    var sectionIndex = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCells()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
     
    //MARK: - Set data
    func setData(data: Any?, sectionIndex: Int) {
        if let data = data as? ExploreModel {
            videos = data.nodes
            self.sectionIndex = sectionIndex
        }
    }
    
    //MARK: - Register cells here...
   func registerCells() {
    let nib = UINib(nibName: "ExploreCollectionViewCell", bundle: nil)
    collectionView?.register(nib, forCellWithReuseIdentifier: cellReuseIdentifier)
   }
    
    //MARK: - Get thumbnail image
    func createThumbnailOfVideoFromRemoteUrl(url: String, indexPath: IndexPath) {
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
        
            let asset = AVAsset(url: URL(string: url)!)
            let assetImgGenerate = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            let time = CMTimeMakeWithSeconds(0, preferredTimescale: 600)
            do {
                let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage: img)
                 
              DispatchQueue.main.async {
                let cell = self?.collectionView.cellForItem(at: indexPath) as? ExploreCollectionViewCell
                cell?.imageView.image = thumbnail
              }
            } catch {
              print(error.localizedDescription)
            }
        }
    }
}

//MARK: - Collection view datasource
extension ExploreTableViewCell: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! ExploreCollectionViewCell
        cell.imageView.image = nil
        createThumbnailOfVideoFromRemoteUrl(url: videos?[indexPath.row].video.encodeUrl ?? "", indexPath: indexPath)
        return cell
    }
}

//MARK: - Collection view delegate
extension ExploreTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.onItemSelected(sectionIndex: sectionIndex, videoIndex: indexPath.row)
        
    }
}

extension ExploreTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 250)
    }
}
