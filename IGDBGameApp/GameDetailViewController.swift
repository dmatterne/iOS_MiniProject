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
    
    var favGame: Favorites?
    
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
        
        if let imageId = selectedGame.coverCloudinaryId {
        
            if let checkedUrl = URL(string: "https://res.cloudinary.com/igdb/image/upload/t_thumb/" + imageId + ".jpg") {
                gameImage.contentMode = .scaleAspectFit
                downloadImage(url: checkedUrl)
            }

        }
        
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
                
//                print(res[0].gameId)
                
                self.favGame = res[0]
                
            
            
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
        addFav.name = selectedGame.name
        addFav.cloudinary_id = selectedGame.coverCloudinaryId!
        addFav.isActive = true
        
      
        do {
        
        try context.save()
            
            self.AddToFavorites.isEnabled = false
            self.removeFavorite.isEnabled = true
            favGame = addFav
            
            
        } catch let error {
        
            print(error)
        }
        
    }
    
    
    
    @IBAction func removeFromFavorites(_ sender: UIButton) {
        
        do {
            
            if let test = favGame {
            
                context.delete(test)
                try context.save()
                
                self.removeFavorite.isEnabled = false
                self.AddToFavorites.isEnabled = true
                
                
            }
        } catch let error {
        
            print(error)
        
        }
        
        
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { (data, response, error)  in
            DispatchQueue.main.sync() { () -> Void in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                self.gameImage.image = UIImage(data: data)
            }
        }
    }
    

   
}
