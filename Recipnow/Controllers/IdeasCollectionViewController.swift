//
//  IdeasCollectionViewController.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 08/03/2022.
//

import UIKit
import FirebaseAuth
import Combine

class IdeasCollectionViewController: UICollectionViewController {
    
    var ideaRecipes: [IRecipe] = []
    
    var subscriptions: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signOut()
        shuffle()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        RecipeIdeaApi.shared.requestIdeas()
            .receive(on: DispatchQueue.main)
            .sink { completion in
            switch completion{
            case .finished:
                print("Ideas Succeeded")
            case .failure(let err):
                print(err.localizedDescription)
            }
        } receiveValue: {[weak self] recipes in
            if let recipes = recipes{
                self?.ideaRecipes = recipes.results
                
                self?.collectionView.reloadData()
               
            }
        }.store(in: &subscriptions)

//        FirebaseManager.shared.getFavorites { recipes  in
//            for recipe in recipes {
//                print(recipe)
//            }
//        }
    }
    
   
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return ideaRecipes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let recipe = ideaRecipes[indexPath.row]
        
        let address = ideaRecipes[indexPath.row].image
        // Configure the cell
        if let cell = cell as? IdeasCollectionViewCell{
            cell.populate(with: recipe, address: address ?? "failed to get ideas")
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let recipe = ideaRecipes[indexPath.item]
        
        self.performSegue(withIdentifier: "details", sender: recipe)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
      
        if segue.identifier == "details"{
            
            guard let selectedRecipe = sender as? IRecipe else {return}
            
            guard let dest = segue.destination as? IdeaDetailsViewController else {return}
            
            guard let id = selectedRecipe.id else {return}
            
            dest.selectedTitle = selectedRecipe.title
            dest.selectedID = String(describing: id)
    
            guard let url = URL(string: selectedRecipe.image!) else {return}

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


extension IdeasCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 300)
    }
}

extension IdeasCollectionViewController{
    func shuffle(){
        let action = UIAction {[weak self] _ in
            self?.ideaRecipes.shuffle()
            self?.collectionView.reloadData()
          }

          let shuffleBBI =  UIBarButtonItem(title: "Mix", image: UIImage(systemName: "repeat"), primaryAction: action, menu: .none)

          navigationItem.rightBarButtonItem = shuffleBBI
    }
}
