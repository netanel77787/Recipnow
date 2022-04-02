//
//  SearchCollectionViewController.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 12/03/2022.
//

import UIKit
import Combine

class SearchCollectionViewController: UICollectionViewController, UISearchControllerDelegate {
    var labelText: String?
    
    @IBOutlet weak var label: UILabel!
    
    let search = UISearchController(searchResultsController: nil)
    
    var recipes: [SRecipe] = []
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
      initSearch()
    }
    
    var subscriptions: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = labelText
        
       
        
        collectionView.delegate = self
        collectionView.dataSource = self
      
        
    }
    
   
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return recipes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
         let image = recipes[indexPath.item].image
        
        let recipe = recipes[indexPath.item]
        
        // Configure the cell
        if let cell = cell as? SearchCollectionViewCell{

            cell.populate(with: recipe, address: image ?? "Failed to get search Image")
        }
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let recipe = recipes[indexPath.item]
        
        self.performSegue(withIdentifier: "details", sender: recipe)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "details"{
            
            guard let selectedRecipe = sender as? SRecipe else {return}
            
            guard let dest = segue.destination as? SearchDetailsViewController else {return}
            
            guard let id = selectedRecipe.id else {return}
            
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
           
        }
    }

}


extension SearchCollectionViewController{
    func initSearch(){
        search.searchResultsUpdater = self
        
        search.delegate = self
        
        
   
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
                    
                self?.recipes = result.searchResults[0].results
                self?.collectionView.reloadData()

            }.store(in: &subscriptions)

    }

}


extension SearchCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 500, height: 500)
    }
}
