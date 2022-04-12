//
//  RandomCollectionViewController.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 05/03/2022.
//

import UIKit
import Combine

class RandomCollectionViewController: UICollectionViewController {

    var randomRecipes: [RRecipe] = []
    
    var subscriptions : Set<AnyCancellable> = []
    
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
                    self.randomRecipes = recipes.recipes
                    self.collectionView.reloadData()
                }
                
                
            }.store(in: &subscriptions)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        
        reloadRandom()
        returnRandom()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        reloadItem()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let recipe = randomRecipes[indexPath.item]
        
        self.performSegue(withIdentifier: "details", sender: recipe)
        
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
            dest.selectedInstructions = selectedRecipe.instructions
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
                self?.reloadItem()
         
          }

          let reloadItemBBI =  UIBarButtonItem(title: "Reload recipe", image: UIImage(systemName: "arrow.clockwise"), primaryAction: action, menu: .none)

          navigationItem.rightBarButtonItem = reloadItemBBI
    }
    
   
    
    func returnRandom(){
        let action = UIAction {[weak self] _ in
            let ind =  IndexPath(item: 1, section: 0)
           
            

          }

          let returnItemBBI =  UIBarButtonItem(title: "Return recipe", image: UIImage(systemName: "return"), primaryAction: action, menu: .none)

          navigationItem.leftBarButtonItem = returnItemBBI
    }
}
