//
//  ExploreViewController.swift
//  Assignment_iOS
//
//  Created by Mohammad Dijoo on 12/10/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import UIKit

protocol CollectionViewItemSelectedDelegate {
    func onItemSelected(sectionIndex: Int, videoIndex: Int)
}

class ExploreViewController: UIViewController {
    
    //MARK: Variables and constants
    let cellReuseIdentifier : String = "ExploreTableViewCell"
    var viewModel : ExploreViewModel?
    var delegate : CollectionViewItemSelectedDelegate?

    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupViews()
    }

    //MARK: - Setup Views
    func setupViews() {

    }

    //MARK: - Register cells here...
       func registerCells() {
           let nib = UINib(nibName: String(describing: ExploreTableViewCell.self), bundle: nil)
           tableView.register(nib, forCellReuseIdentifier: cellReuseIdentifier)
       }
    }

//MARK: Tableview datasource
extension ExploreViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.dataModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.dataModel?[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ExploreTableViewCell
        
        cell.delegate = self
        cell.setData(data: viewModel?.dataModel?[indexPath.section], sectionIndex: indexPath.section)

        return cell
    }
}

//MARK: - Tableview delegate
extension ExploreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .white
        let header = view as! UITableViewHeaderFooterView
        header.backgroundColor = .white
    }
}

//MARK: - CollectionView Item selected
extension ExploreViewController: ItemSelectedDelegate {
    func onItemSelected(sectionIndex: Int, videoIndex: Int) {
        delegate?.onItemSelected(sectionIndex: sectionIndex, videoIndex: videoIndex)
    }
}
