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
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        
        reloadRandom()
        
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let recipe = randomRecipes[indexPath.item]
        
        self.performSegue(withIdentifier: "details", sender: recipe)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "details"{
            let minutes = " Minutes making"
            
            guard let selectedRecipe = sender as? RRecipe else {return}
            
            guard let dest = segue.destination as? RandomDetailsViewController else {return}
            
            guard let id = selectedRecipe.id else {return}
            
            guard let readyMinutes = selectedRecipe.readyInMinutes else {return}
            
            dest.selectedTitle = selectedRecipe.title
            dest.selectedID =  "\(String(describing: id))"
            dest.selectedSummary = selectedRecipe.summary
            dest.selectedInstructions = selectedRecipe.instructions
            dest.selectedMinutes =  "\(String(describing: readyMinutes))" + "\(minutes)"
            
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
        
        let address = randomRecipes[indexPath.item].image
        
        if let cell = cell as? RandomCollectionViewCell{
            cell.populate(with: recipe, address: address ?? "Failed to get random Image")
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
            if let random = self?.randomRecipes.randomElement(){
                self?.randomRecipes.remove(at: (self?.randomRecipes.count ?? 0)-1)
             
                self?.randomRecipes.append(random)
                self?.randomRecipes.shuffle()
                self?.collectionView.reloadData()
            }
            
          }

          let shuffleBBI =  UIBarButtonItem(title: "Reload", image: nil, primaryAction: action, menu: .none)

          navigationItem.rightBarButtonItem = shuffleBBI
    }
}
