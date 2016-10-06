//
//  APIService.swift
//  IGDBGameApp
//
//  Created by Stannis Baratheon on 06/10/16.
//  Copyright © 2016 Training. All rights reserved.
//

import Foundation


class APIService {


    var basicUrl = "https://igdbcom-internet-game-database-v1.p.mashape.com/"
    var gameArray = [Games] ()

    func fetchGames(closeFunc: @escaping ([Games]) -> Void)  {
        
        gameArray = [Games] ()
        
        let myUrl = URL(string: basicUrl + "/games/?fields=*&limit=25")
        
        var myUrlRequest = URLRequest(url: myUrl!)
        
        myUrlRequest.addValue("X075Wf6IHLmsh4pfqnr2RxWeokjqp1Kx0OZjsnNv8ZqotK3En8", forHTTPHeaderField: "X-Mashape-Key")
        myUrlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        let task = URLSession.shared.dataTask(with: myUrlRequest) {
            (data, response, error) in
            
             do {
                
                let gameFeed = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Array<Dictionary<String,Any>>
                
                for g in gameFeed {
                    
                    self.parseGame(g: g)
                    
                }
                
                closeFunc(self.gameArray)
                
//                self.getImages()
             
            } catch let error {
            
                print(error)
            
            }
            
        
        }
        task.resume()

        
    }
    
    
    func parseGame (g: Dictionary<String,Any>) {
    
        print(g)
        
        let idx = g["id"] as! Int
        let namex = g["name"] as! String
        let slugx = g["slug"] as! String?
        let releaseDatex = g["first_release_date"] as! Int?
        let alternativeNamex = g["alternative_name"] as! String?
        let ratingx = g["rating"] as! Double?
        let urlx = g["url"] as! String?
        let createdAtx = g["created_at"] as! Int?
        let updatedAtx = g["updated_at"] as! Int?
        let summaryx = g["summary"] as! String?
        
        let hypesx = g["hypes"] as! Int?
        let popularityx = g["popularity"] as! Double?
        let aggregatedRatingx = g["aggregated_rating"] as! Double?
        let ratingCountx = g["rating_count"] as! Int?
        let categoryx = g["category"] as! Int?
        let pegix = g["pegi"] as! Int?
        
        let coverx = g["cover"] as! Dictionary<String,AnyObject>?
        
        let coverCloudinaryIdx = coverx?["cloudinary_id"] as! String?
        let coverHeightx = coverx?["height"] as! Int?
        let coverWidthx = coverx?["width"] as! Int?
        
        
        self.gameArray.append(Games(
            gameId: idx,
            name: namex,
            slug: slugx,
            alternativeName: alternativeNamex,
            rating: ratingx,
            url: urlx,
            createdAt: createdAtx,
            updatedAt: updatedAtx,
            Summary: summaryx,
            hypes: hypesx,
            popularity: popularityx,
            aggregatedRating: aggregatedRatingx,
            ratingCount: ratingCountx,
            category: categoryx,
            firstReleaseDate: releaseDatex,
            pegi: pegix,
            coverCloudinaryId: coverCloudinaryIdx,
            coverHeight: coverHeightx,
            coverWidth: coverWidthx,
            taskIdentifier: nil
            
        ))
    
    }
    
    
//    func fetchCover() {
//
//
//        for game in gameArray {
//
//            var myGame = game
//            let myImageUrl = URL(string: game.coverUrl!)
//
//             let sessionDownloadTask = URLSession.shared.downloadTask(with: myImageUrl!) {
//
//                myGame.taskIdentifier = sessionDownloadTask.taskIdentifier
//                let index = gameArray.index(where: {$0.name == myGame.name})
//                gameArray[index!] = myGame
//                sessionDownloadTask.resume()
//
//            }
//            
//        }
//    
//    }



}
