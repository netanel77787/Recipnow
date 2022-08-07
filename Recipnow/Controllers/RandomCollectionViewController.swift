//
//  RandomCollectionViewController.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 05/03/2022.
//

import UIKit
import Combine
import FirebaseDatabase

class RandomCollectionViewController: UICollectionViewController,RandomCollectionViewCellDelegate {

    func showDetails(recipe: RRecipe) {
        self.performSegue(withIdentifier: "details", sender: recipe)
    }
    func addToFavorites(recipe: RRecipe) {
        showSuccess(title: "Added successfully")
    }
    func errorAddingToFavorites(err: Error) {

        showError(title: err.localizedDescription)
    }
    var randomRecipes: [RRecipe] = []
    
    var subscriptions : Set<AnyCancellable> = []
    var prev : RRecipe?
    var nextRecipe : RRecipe?
    
     func reloadItem() {
        RandomRecipeApi.shared.randomRequest()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion{
                    
                case .finished:
                    print("Randoms succedeed")
                case .failure(_):
                    print("Randoms failed")
                }
            } receiveValue: { recipes in
                if let recipes = recipes{
                    let r = recipes.recipes[0]
                
                        let fav = Favorite(name: r.name ?? "", recipeID: r.id ?? 0, image: r.image ?? "", link: r.link ?? "", content: r.content ?? "")

                    Database.database()
                            .reference(withPath: "Cache")
                            .child("Random")
                            .child(String(r.id!))
                            .setValue(fav.dict)
                    self.randomRecipes = recipes.recipes
                    self.collectionView.reloadData()
                }
                
                
            }.store(in: &subscriptions)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .black
        
        reloadItem()
        reloadRandom()
        returnRandom()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "details"{
            let minutes = " Minutes to prepare this recipe"
            
            guard let selectedRecipe = sender as? RRecipe,
                  let dest = segue.destination as? RandomDetailsViewController,
                  let id = selectedRecipe.id,
                  let readyMinutes = selectedRecipe.readyInMinutes
            else {return}
            
          
            
            dest.selectedTitle = selectedRecipe.name
            dest.selectedID =  "\(String(describing: id))"
            dest.selectedSummary = selectedRecipe.content

            dest.selectedMinutes =  "\(String(describing: readyMinutes))" + "\(minutes)"
            
            dest.recipe = selectedRecipe
            
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

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return randomRecipes.count
    }

    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    
        let recipe = randomRecipes[indexPath.item]
        
        let imageAddress = randomRecipes[indexPath.item].image
        
        if let cell = cell as? RandomCollectionViewCell{
            cell.delegate = self
            cell.populate(with: recipe, address: imageAddress ?? "Failed to get random Image")
          
        }
    
        return cell
    }

    
}


extension RandomCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 500, height: 500)
    }
}

extension RandomCollectionViewController{
    
    
    func reloadRandom(){
        let action = UIAction {[weak self] _ in
            self?.prev = self?.randomRecipes[0]
            self?.reloadItem()
        }

          let reloadItemBBI =  UIBarButtonItem(title: "Reload recipe", image: UIImage(systemName: "arrow.clockwise"), primaryAction: action, menu: .none)
          navigationItem.rightBarButtonItem = reloadItemBBI
    }
    
   
    
    func returnRandom(){
        let actionPrev = UIAction {[weak self] _ in
            if let prev = self?.prev {
                self?.nextRecipe = self?.randomRecipes[0]
                self?.randomRecipes = [prev]
                self?.collectionView.reloadData()
            }
          }
        
        let actionNext = UIAction {[weak self] _ in
            if let next = self?.nextRecipe {
                self?.randomRecipes = [next]
                self?.nextRecipe = nil
                self?.collectionView.reloadData()
            }else {
                self?.showErrorDelay(title: "No next Recipe",delay: 1)
            }
          }

          let returnItemBBI =  UIBarButtonItem(title: "Return recipe", image: UIImage(systemName: "return"), primaryAction: actionPrev, menu: .none)

        
        let returnItemBBIRight =  UIBarButtonItem(title: "Next recipe", image: UIImage(systemName: "return.right"), primaryAction: actionNext, menu: .none)

        navigationItem.leftBarButtonItems = [returnItemBBI,returnItemBBIRight]
   
    }
    

}
