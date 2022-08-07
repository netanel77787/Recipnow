//
//  SearchCollectionViewController.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 12/03/2022.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Combine

class SearchCollectionViewController: UICollectionViewController, UISearchControllerDelegate, UITextFieldDelegate,
SearchCollectionViewCellDelegate {
    
    
    func addedToFavorites(recipe: SRecipe) {
        showSuccess(title:"Added successfully ")
    }
    
    func showDetails(recipe: SRecipe) {
        self.performSegue(withIdentifier: "details", sender: recipe)
    }
    
    func errorAddingToFavorites(err: Error) {
        showError(title: err.localizedDescription)
    }
    var searchRecipes: [SRecipe] = []
    var preSearchText: String?
    var subscriptions: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        initSearch()
        
        collectionView.backgroundColor = .black
        UINavigationBar().tintColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
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
            cell.delegate  = self
            cell.populate(with: recipe, address: image ?? "Failed to get search Image")
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "details" {
            
            guard let selectedRecipe = sender as? SRecipe,
                    let dest = segue.destination as? SearchDetailsViewController,
                  let id = selectedRecipe.id
            else {return}

           
            dest.selectedName = selectedRecipe.name
            dest.selectedID =  "\(String(describing: id))"
            dest.selectedContent = selectedRecipe.content

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
        
        search.searchBar.placeholder = "What recipe you would like to search?"
       
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
                
                
                for r in self!.searchRecipes {
                    Database.database()
                        .reference(withPath: "Cache")
                        .child("Search")
                        .child(String(r.id!))
                        .setValue(Favorite.init(name:r.name ?? "",recipeID:r.id ?? 0,image:r.image ?? "",link:r.link ?? "", content: r.content ?? "").dict)
                }
          

            }.store(in: &subscriptions)

    }

}


extension SearchCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 500, height: 500)
    }
}
