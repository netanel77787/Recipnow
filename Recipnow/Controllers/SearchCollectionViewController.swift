//
//  SearchCollectionViewController.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 12/03/2022.
//

import UIKit
import Combine

class SearchCollectionViewController: UICollectionViewController, UISearchControllerDelegate {
   

    var searchRecipes: [SRecipe] = []
    var preSearchText: String?
    var subscriptions: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        initSearch()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    
    func preSearch(with text: String?) {
        if let searchController = navigationItem.searchController {
            searchController.searchBar.text = text
            updateSearchResults(for:searchController)
        }

    }
   
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return searchRecipes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
         let image = searchRecipes[indexPath.item].image
        
        let recipe = searchRecipes[indexPath.item]
        
        // Configure the cell
        if let cell = cell as? SearchCollectionViewCell{

            cell.populate(with: recipe, address: image ?? "Failed to get search Image")
        }
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let recipe = searchRecipes[indexPath.item]
        
        self.performSegue(withIdentifier: "details", sender: recipe)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "details"{
            
            guard let selectedRecipe = sender as? SRecipe,
                    let dest = segue.destination as? SearchDetailsViewController,
                  let id = selectedRecipe.id
            else {return}

           
            dest.selectedName = selectedRecipe.name
            dest.selectedID =  "\(String(describing: id))"

            guard let url = URL(string: selectedRecipe.image ?? "Cannot get recent image search") else {return}

            URLSession.shared.dataTask(with: url) { data, _, err in
                guard let data = data
                else {
                    return
                }

                let image = UIImage(data: data)
                    dest.selectedImage = image

            }.resume()
            dest.recipe = selectedRecipe
        }
    }

}


extension SearchCollectionViewController{
    func initSearch(){
        
        let search = UISearchController(searchResultsController: nil)
        
        search.searchResultsUpdater = self
        
        search.delegate = self
        
        search.searchBar.placeholder = "Please type recipe name to search"
       
        search.searchBar.text = preSearchText
        
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
                    
                self?.searchRecipes = result.searchResults[0].results
                self?.collectionView.reloadData()

            }.store(in: &subscriptions)

    }

}


extension SearchCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 500, height: 500)
    }
}
