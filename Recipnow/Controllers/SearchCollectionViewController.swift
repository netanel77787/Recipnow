//
//  SearchCollectionViewController.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 12/03/2022.
//

import UIKit


class SearchCollectionViewController: UICollectionViewController {
   
    

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


extension SearchCollectionViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        
        print(text)
    }
    
    func initSearch(){
        let search = UISearchController(searchResultsController: nil)
        
        search.searchResultsUpdater = self
        
        search.searchBar.placeholder = "Type recipe name for search"
        
        navigationItem.searchController = search
    }
    
}
