//
//  FavoritesCollectionViewController.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 09/04/2022.
//

import UIKit


class FavoritesCollectionViewController: UICollectionViewController, UISearchControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        initSearch()
    }




    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    

}


extension FavoritesCollectionViewController{
    func initSearch(){
        
        let search = UISearchController(searchResultsController: nil)
        
        search.searchResultsUpdater = self
        
        search.delegate = self
        
        search.searchBar.placeholder = "type recipe name to find it"
        
        navigationItem.searchController = search

    }
}

extension FavoritesCollectionViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

