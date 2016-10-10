//
//  GameDetailViewController.swift
//  IGDBGameApp
//
//  Created by Stannis Baratheon on 06/10/16.
//  Copyright © 2016 Training. All rights reserved.
//

import UIKit
import CoreData

class GameDetailViewController: UIViewController {

    @IBOutlet weak var gameName: UILabel!
    
    @IBOutlet weak var gameImage: UIImageView!
    
    @IBOutlet weak var gameURL: UILabel!
    
    @IBOutlet weak var gameSummary: UITextView!
    
    @IBOutlet weak var AddToFavorites: UIButton!
    
    @IBOutlet weak var removeFavorite: UIButton!
    
    var favGame: Favorite
    
    
    
    var selectedGame: Games!
    var context: NSManagedObjectContext!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        AddToFavorites.isEnabled = false
        removeFavorite.isEnabled = false
        checkIfFavorite()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameName.text = "Name: " + selectedGame!.name
        gameName.font = UIFont.systemFont(ofSize: 13.0)
        gameURL.text = "URL: " + selectedGame!.url!
        gameURL.font = UIFont.systemFont(ofSize: 13.0)
        gameSummary.text = selectedGame?.Summary
        gameSummary.font = UIFont.systemFont(ofSize: 13.0)

        let del = UIApplication.shared.delegate as! AppDelegate
        
        context = del.persistentContainer.viewContext
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
  
    
    func checkIfFavorite() {
    
        let request: NSFetchRequest<Favorites> = Favorites.fetchRequest()
        
        let predicate = NSPredicate(format: "gameId == %i", selectedGame.gameId)
        
        request.fetchLimit = 1
    
        request.predicate = predicate
        
        
        
        
        let asyncRequest = NSAsynchronousFetchRequest<Favorites> (fetchRequest: request) {
            
            (result) in
            
            var res = result.finalResult ?? []
            
            
            
            if res.count == 0 {
            
            
                self.AddToFavorites.isEnabled = true
                self.removeFavorite.isEnabled = false
                
            
            } else {
                
                
                
            
            
                if res[0].isActive == false {
                
                
                    self.AddToFavorites.isEnabled = true
                    self.removeFavorite.isEnabled = false
                
                } else {
                
                    self.removeFavorite.isEnabled = true
                
                }
                
            }
            
            
        }
        
        do {
            
            try context.execute(asyncRequest)
        
        
        } catch let error {
        
            print(error)
        
        }
            
    
    }

    
    @IBAction func addToFavorites(_ sender: UIButton) {
        
        let addFav = NSEntityDescription.insertNewObject(forEntityName: "Favorites", into: context) as! Favorites
        
        addFav.gameId = selectedGame.gameId
        addFav.isActive = true
        
      
        do {
        
        try context.save()
            
            self.AddToFavorites.isEnabled = true
            self.removeFavorite.isEnabled = false
            
            
        } catch let error {
        
            print(error)
        }
    
        
        
        
        
        
    }
    
    
    
    @IBAction func removeFromFavorites(_ sender: UIButton) {
        
//        var fav: Favorites
//        
//        fav.gameId = selectedGame.gameId
//        fav.isActive = false
//        
//        
//        context.delete(fav)
        
        
    }
   
}
