//
//  SearchCollectionViewController.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 12/03/2022.
//

import UIKit
import Combine

class SearchCollectionViewController: UICollectionViewController {
   
    var results = [Results]()
    
    var recipes: [SRecipe] = []
    
    var subscriptions: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        initSearch()
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return recipes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let recipe = recipes[indexPath.item]
        
        let address = results[indexPath.item].results
        
//        let id = recipes[indexPath.row].id
//
//        let result = results[indexPath.item]
        
        // Configure the cell
        if let cell = cell as? SearchCollectionViewCell{
//            guard let image = recipes[indexPath.row].image else {return UICollectionViewCell()}
//
//            let imageAddress = image
//            cell.addressPopulate(address: recipe)
            cell.populate(with: recipe)
        }
        return cell
    }

}

extension SearchCollectionViewController{
    func initSearch(){
        let search = UISearchController(searchResultsController: nil)
        
        search.searchResultsUpdater = self
        
        search.searchBar.placeholder = "Type recipe name for searching"
        
        navigationItem.searchController = search
    }
}

extension SearchCollectionViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else {return}
        
        SearchRecipesApi.shared.requestSearch(query: text)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion{

                case .finished:
                    print("Search Succeeded")
                case .failure(let err):
                    print(err)
                }
            } receiveValue: {[weak self]  result in

                self?.results = result.searchResults
                self?.collectionView.reloadData()
                print(result)
         
            }.store(in: &subscriptions)

    }

}


extension SearchCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 400)
    }
}
