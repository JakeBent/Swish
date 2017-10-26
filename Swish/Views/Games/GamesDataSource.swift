//
//  GamesDataSource.swift
//  Swish
//
//  Created by Jacob Benton on 10/24/17.
//  Copyright © 2017 Jacob Benton. All rights reserved.
//

import UIKit

class GamesDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var data = [GamesViewDataSource(), GamesViewDataSource(), GamesViewDataSource(), GamesViewDataSource(), GamesViewDataSource(), GamesViewDataSource(), GamesViewDataSource(), GamesViewDataSource(), GamesViewDataSource(), GamesViewDataSource()]
    
    var didFinishLoading: (() -> Void)?
    
    init(didFinishLoading: (() -> Void)?) {
        super.init()
        self.didFinishLoading = didFinishLoading
        
    }
    
    func refresh() {
        self.didFinishLoading?()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: GamesView = collectionView.dequeue(indexPath: indexPath)
        cell.dataSource = data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.frame.size
    }
}
