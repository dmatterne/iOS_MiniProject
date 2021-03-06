//
//  GameListTableViewController.swift
//  IGDBGameApp
//
//  Created by Stannis Baratheon on 06/10/16.
//  Copyright © 2016 Training. All rights reserved.
//

import UIKit

class GameListTableViewController: UITableViewController, URLSessionDelegate, URLSessionDataDelegate {
    
    
    @IBOutlet weak var refreshList: UIRefreshControl!
    
    var downloading = false
    var gameArray = [Games] ()
    var basicUrl = "https://www.igdb.com/api/v1/games"
    var apiServ = APIService()
    
    var refreshCtrl: UIRefreshControl!
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var cache:NSCache<AnyObject, AnyObject>!

    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
//        let sessionConfig = URLSessionConfiguration.default
//        
//        URLSession.shared.configuration = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
//        refreshList.addTarget(self, action: #selector(apiServ.fetchGames), for: .valueChanged)
        
        downloading = true
        
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        apiServ.fetchGames(closeFunc: closeFunction)
        
        
        session = URLSession.shared
        task = URLSessionDownloadTask()
        
//        self.refreshCtrl = UIRefreshControl()
//        self.refreshCtrl.addTarget(self, action: #selector(GameListTableViewController.refreshTableView), for: .valueChanged)
//        self.refreshControl = self.refreshCtrl
        
        
        self.cache = NSCache()
 
    }
    
    
//    func refreshTableView(){
//        
//        let url:URL! = URL(string: "https://itunes.apple.com/search?term=flappy&entity=software")
//        task = session.downloadTask(with: url, completionHandler: { (location: URL?, response: URLResponse?, error: Error?) -> Void in
//            
//            if location != nil{
//                let data:Data! = try? Data(contentsOf: location!)
//                do{
//                    let dic = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as AnyObject
//                    self.tableData = dic.value(forKey : "results") as? [AnyObject]
//                    DispatchQueue.main.async(execute: { () -> Void in
//                        self.tableView.reloadData()
//                        self.refreshControl?.endRefreshing()
//                    })
//                }catch{
//                    print("something went wrong, try again")
//                }
//            }
//        })
//        task.resume()
//    }
    

    func closeFunction(array: [Games]) {
   
        
        self.gameArray = array
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

        
    
    }
    
//    func refreshJsonFeed() {
//    
//        if !downloading {
//            
//            downloading = true
//            UIApplication.shared.isNetworkActivityIndicatorVisible = true
//            gameArray = apiServ.fetchGames() {
//             
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
//        
//        }
//        
//        
//    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gameArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameListCell", for: indexPath)
        let curGame = gameArray[indexPath.row]
        
        cell.textLabel?.text = curGame.name
        cell.textLabel?.font = UIFont.systemFont(ofSize: 10.0)
        cell.imageView?.image = UIImage(named: "cd.jpeg")
        
        if (self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil) {
            
            cell.imageView?.image = self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
            
        } else {
            
            if let imagecloudid = curGame.coverCloudinaryId {
            
                let artworkUrl = "https://res.cloudinary.com/igdb/image/upload/t_thumb/" + imagecloudid + ".jpg"
                let url:URL! = URL(string: artworkUrl)
                task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                    if let data = try? Data(contentsOf: url){
                    
                        DispatchQueue.main.async(execute: { () -> Void in
                        
                            if let updateCell = tableView.cellForRow(at: indexPath) {
                                let img:UIImage! = UIImage(data: data)
                                updateCell.imageView?.image = img
                                self.cache.setObject(img, forKey: (indexPath as NSIndexPath).row as AnyObject)
                            }
                        })
                    }
                })
                task.resume()
            
            }
        }
        
        return cell
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("session")
        let index = gameArray.index(where: {$0.taskIdentifier == task.taskIdentifier})
        
        if error == nil {
            print("task \(index) finished!")
        }
        else{
            print("Error: \(error)")
        }
//        checkForRemainingTasks()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let dest = segue.destination as! GameDetailViewController
        
        let index = tableView.indexPath(for: sender as! UITableViewCell)
        
        dest.selectedGame = gameArray[index!.row]
        
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
