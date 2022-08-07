//
//  FavoritesCollectionViewController.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 09/04/2022.
//

import UIKit
import Combine


class FavoritesCollectionViewController: UIViewController,
                                         UICollectionViewDataSource,
                                         UICollectionViewDelegateFlowLayout,FavoriteCollectionViewCellDelegate, UISearchControllerDelegate {
   
    func errorRemovingFromFavorites(err: Error) {
        showError(title: err.localizedDescription)
    }
    
    
    func removedFromFavorites(recipe: Favorite) {
        if recipe.category == "Random" {
            favoritesRandom.removeAll { f in
                return f.recipeID == recipe.recipeID && f.name == recipe.name
            }
            
        }else{
            favoritesSearch.removeAll { f in
                return f.recipeID == recipe.recipeID && f.name == recipe.name
            }
            
        }
        collectionView.reloadData()
        showSuccess(title: "Remove succeeded")
    }
    
    var subs = Set<AnyCancellable>()
    var favoritesSearch = [Favorite]()
    var favoritesRandom = [Favorite]()
    
    var favoritesSearchCopy = [Favorite]()
    var favoritesRandomCopy = [Favorite]()
    

    
    lazy var collectionView : UICollectionView = {
        let cView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cView.delegate = self
        cView.dataSource = self
        cView.translatesAutoresizingMaskIntoConstraints = false
        cView.register(FavoriteCollectionViewCell.self,
                       forCellWithReuseIdentifier: FavoriteCollectionViewCell.id)
   
        return cView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initSearch()
        UINavigationBar().tintColor = .black
        view.addSubview(collectionView)
        let c  = [collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),   collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)]
        NSLayoutConstraint.activate(c)
        collectionView.register(Header.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Header.id)

   
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // gets all the user favoirets from db to collection view
        FirebaseManager.getUserFavorites() {[weak self] fav, err in
            if let err = err {
                print(err)
                return
            }
            guard let fav = fav else {
                return
            }
            self?.favoritesRandom = fav.random
            self?.favoritesSearch = fav.search
            self?.favoritesRandomCopy = fav.random
            self?.favoritesSearchCopy = fav.search
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        
        }
    
    }

   
   
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/2),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: size)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(500),
            heightDimension: .fractionalWidth(5/7)),
            subitem: item, count:2)
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 4)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.25/5))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 100, bottom: 0, trailing: 100)
        section.supplementariesFollowContentInsets = false
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [header]
        
        return UICollectionViewCompositionalLayout(section: section)
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            performSegue(withIdentifier: "detailsRandom", sender: favoritesRandom[indexPath.item])
        }else if indexPath.section == 1 {
            performSegue(withIdentifier: "detailsSearch", sender: favoritesSearch[indexPath.item])
        }
    }
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
         
         if section == 0 {
             return favoritesRandom.count
         }else if section == 1{
             return favoritesSearch.count
         }else {
             return 0
         }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "detailsRandom" {
            popRe(dest: segue.destination as! RandomDetailsViewController, selectedRecipe: sender as! Favorite)
        } else if segue.identifier == "detailsSearch" {
            popRe(dest: segue.destination as! SearchDetailsViewController, selectedRecipe: sender as! Favorite)
            
        }
    }
    
    func popRe(dest: SearchDetailsViewController,selectedRecipe : Favorite) {
        print(selectedRecipe)
        dest.selectedName = selectedRecipe.name
        dest.selectedID =  "\(String(describing: selectedRecipe.recipeID))"
        dest.selectedContent = selectedRecipe.content
        dest.selectedImage = UIImage(systemName: "photo")
        guard let url = URL(string: selectedRecipe.image ?? "Cannot get recent image search") else {return}

        URLSession.shared.dataTask(with: url) { data, _, err in
            guard let data = data
            else {
                return
            }

            let image = UIImage(data: data)
              
            dest.selectedImage = image

        }.resume()
        dest.recipeFav = selectedRecipe
    }
    
    func popRe(dest: RandomDetailsViewController,selectedRecipe : Favorite) {
        print(selectedRecipe)
        dest.selectedTitle = selectedRecipe.name
        dest.selectedID =  "\(String(describing: selectedRecipe.recipeID))"
        dest.selectedSummary = selectedRecipe.content
        guard let url = URL(string: selectedRecipe.image ?? "Cannot get recent image search") else {return}

        URLSession.shared.dataTask(with: url) { data, _, err in
            guard let data = data
            else {
                return
            }
            
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                dest.imageView.image = image
            }

        }.resume()
        dest.recipeFav = selectedRecipe
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Header.id, for: indexPath) as! Header
        header.config(sectionTitle:indexPath.section == 0 ? "Random recipes" : "Search recipes")
        return header
    }
    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.id, for: indexPath) as! FavoriteCollectionViewCell
         if indexPath.section == 0 {
             cell.favorite = favoritesRandom[indexPath.row]
         }else if indexPath.section == 1 {
             cell.favorite = favoritesSearch[indexPath.row]
         }
         
         cell.indexPath = indexPath
         cell.delegate  = self
        return cell
    }
    
    


}




extension FavoritesCollectionViewController{
    func initSearch(){
        
        let search = UISearchController(searchResultsController: nil)
        
        search.searchResultsUpdater = self
        
        search.delegate = self
   
        
        search.searchBar.placeholder = "What recipe you would like to find?"
        search.searchBar.tintColor = .white
        navigationItem.searchController = search

    }
}

extension FavoritesCollectionViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        if searchText.count < 1 {
            print(favoritesSearchCopy)
            self.favoritesSearch = favoritesSearchCopy
            self.favoritesRandom = favoritesRandomCopy
            collectionView.reloadData()
            return
        }
        let filterRandom = favoritesRandomCopy.filter { fav in
            return fav.name.contains(searchText)
        }
        let filterSearch = favoritesSearchCopy.filter { fav in
            return fav.name.contains(searchText)
        }
        self.favoritesSearch = filterSearch
        self.favoritesRandom = filterRandom
        collectionView.reloadData()
    }
}

