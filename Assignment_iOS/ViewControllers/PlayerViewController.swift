//
//  PlayerViewController.swift
//  Assignment_iOS
//
//  Created by Mohammad Dijoo on 12/10/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import UIKit
import AVKit

protocol PlayerViewDelegate {
    func onBackPressed()
}

class PlayerViewController: UIViewController {

    //MARK: - Variables and Constants
    var videos: [VideoModel]?
    let cellReuseIdentifier = "PlayerItemCollectionViewCell"
    var videoIndex: Int?
    var lastVisibleIndex: Int?
    
    var delegate : PlayerViewDelegate?
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    //MARK: - IBActions
    @IBAction func backButtonPressed(_ sender: Any) {
        delegate?.onBackPressed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        collectionView.reloadData()
        
        DispatchQueue.main.async {[weak self] in
            //Scroll to the selected item
            self?.collectionView.scrollToItem(at: IndexPath(item: self?.videoIndex ?? 0, section: 0), at: .bottom, animated: false)

            self?.lastVisibleIndex = self?.videoIndex
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let index = lastVisibleIndex {
            let cell = getVisibleCell(at: index)
            cell?.player?.pause()
        }
    }
    
    //MARK: - Register cells here...
      func registerCells(){
       let nib = UINib(nibName: cellReuseIdentifier, bundle: nil)
       collectionView?.register(nib, forCellWithReuseIdentifier: cellReuseIdentifier)
      }
    
    //MARK: - Get Visible cell
    func getVisibleCell(at index: Int) -> PlayerItemCollectionViewCell? {
        return collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? PlayerItemCollectionViewCell
    }
}

//MARK: - CollectionView datasource
extension PlayerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! PlayerItemCollectionViewCell
        cell.setData(url: videos?[indexPath.row].video.encodeUrl)
        return cell
    }
}

extension PlayerViewController: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //Pausing previous video
        if let index = lastVisibleIndex {
            let cell = getVisibleCell(at: index)
            cell?.player?.pause()
        }
        let visibleIndex = Int(targetContentOffset.pointee.y / collectionView.frame.height)
        let cell = getVisibleCell(at: visibleIndex)
        cell?.player?.play()
        lastVisibleIndex = visibleIndex
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == videoIndex ?? 0 + 1 {
            DispatchQueue.main.async {
                let cell = self.getVisibleCell(at: indexPath.row)
                cell?.player?.play()
            }
        }
    }
}

extension PlayerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cvRect = collectionView.frame
        return CGSize(width: cvRect.width, height: cvRect.height)
    }
}
