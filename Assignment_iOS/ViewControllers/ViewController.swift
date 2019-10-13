//
//  ViewController.swift
//  Assignment_iOS
//
//  Created by Abdul Basit on 12/10/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import UIKit

class ViewController: UIPageViewController {

    //MARK: - Variables and Constants
    let exploreViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ExploreViewController") as! ExploreViewController
    let playerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PlayerViewController") as! PlayerViewController
    
    var viewModel : ExploreViewModel?
    var url: String?

        
    override func viewDidLoad() {
        dataSource = self
        playerViewController.delegate = self
        exploreViewController.delegate = self
        viewModel = ExploreViewModel(delegate: self)
    }
    
    required init?(coder: NSCoder) {
        //Set transition style and navigation orientation
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
}

//MARK: - Pageviewcontroller datasource
extension ViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController == exploreViewController {
            return nil
        }
        return exploreViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController == playerViewController{
            return nil
        }
        if playerViewController.videos == nil {
            playerViewController.videoIndex = 0
            playerViewController.videos = viewModel?.dataModel?.first?.nodes
        }
        return playerViewController
    }
}

//MARK: - Collectionview cell select delegate
extension ViewController: CollectionViewItemSelectedDelegate {
    //Handled item selection of explore collectionview items here
    func onItemSelected(sectionIndex: Int, videoIndex: Int) {
        playerViewController.videos = viewModel?.dataModel?[sectionIndex].nodes
        playerViewController.videoIndex = videoIndex
        setViewControllers([playerViewController], direction: .forward, animated: true, completion: nil)
    }
}

//MARK: - PlayerView delegate
extension ViewController: PlayerViewDelegate {
    func onBackPressed() {
        //Handled back press of Player view controller here
        setViewControllers([exploreViewController], direction: .reverse, animated: true, completion: nil)
    }
}

//MARK: - View model delegates
extension ViewController : ExploreViewModelDelegate {
    func onDataLoaded() {
        DispatchQueue.main.async { [weak self] in
            self?.exploreViewController.viewModel = self?.viewModel
            self?.url = self?.viewModel?.dataModel?.first?.nodes.first?.video.encodeUrl
            guard let viewController = self?.exploreViewController else {return}
            self?.setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
        }
    }

    func onDataLoadError() {
        print("error occurred")
    }
}
