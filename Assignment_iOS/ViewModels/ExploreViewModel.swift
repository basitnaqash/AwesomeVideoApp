//
//  ExploreViewModel.swift
//  Assignment_iOS
//
//  Created by Abdul Basit on 12/10/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import Foundation

protocol ExploreViewModelDelegate {
    func onDataLoaded()
    func onDataLoadError()
}

class ExploreViewModel {
    //MARK: - Variables and constants
    var delegate : ExploreViewModelDelegate?
    var dataModel : [ExploreModel]?
    
    //MARK: - Initializer
    init(delegate : ExploreViewModelDelegate) {
        self.delegate = delegate
        getData()
    }
    
    //Data from json parsed here
    func getData() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
          if let path = Bundle.main.path(forResource: "assignment", ofType: "json") {
          do {
              let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
              let exploreData = try JSONDecoder().decode([ExploreModel].self, from: data)
              self?.dataModel = exploreData
              DispatchQueue.main.async {
                  self?.delegate?.onDataLoaded()
                print(exploreData)
              }
              } catch {
                    print("error: \(error.localizedDescription)")
                    self?.delegate?.onDataLoadError()
              }
          }
        }
    }
}
