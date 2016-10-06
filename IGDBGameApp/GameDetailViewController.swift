//
//  GameDetailViewController.swift
//  IGDBGameApp
//
//  Created by Stannis Baratheon on 06/10/16.
//  Copyright © 2016 Training. All rights reserved.
//

import UIKit

class GameDetailViewController: UIViewController {

    @IBOutlet weak var gameName: UILabel!
    
    @IBOutlet weak var gameImage: UIImageView!
    
    @IBOutlet weak var gameURL: UILabel!
    
    @IBOutlet weak var gameSummary: UITextView!
    
    var selectedGame: Games?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameName.text = "Name: " + selectedGame!.name
        gameName.font = UIFont.systemFont(ofSize: 13.0)
        gameURL.text = "URL: " + selectedGame!.url!
        gameURL.font = UIFont.systemFont(ofSize: 13.0)
        gameSummary.text = selectedGame?.Summary
        gameSummary.font = UIFont.systemFont(ofSize: 13.0)

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

}
