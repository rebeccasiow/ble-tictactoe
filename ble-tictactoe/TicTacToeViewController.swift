//
//  TicTacToeViewController.swift
//  ble-tictactoe
//
//  Created by Rebecca Siow on 12/5/16.
//  Copyright © 2016 Rebecca Siow. All rights reserved.
//

import UIKit

class TicTacToeViewController: UIViewController {

    @IBOutlet weak var space0: UIImageView!
    
    @IBOutlet weak var space1: UIImageView!
    
    @IBOutlet weak var space2: UIImageView!
    
    @IBOutlet weak var space3: UIImageView!
    
    @IBOutlet weak var space4: UIImageView!
    
    @IBOutlet weak var space5: UIImageView!
    
    @IBOutlet weak var space6: UIImageView!
    
    @IBOutlet weak var space7: UIImageView!
    
    @IBOutlet weak var space8: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TicTacToeViewController viewDidLoad")
        
        space0.image = nil
        space1.image = nil
        space2.image = nil
        space3.image = nil
        space4.image = nil
        space5.image = nil
        space6.image = nil
        space7.image = nil
        space8.image = nil
        
        // Do any additional setup after loading the view.
        
        //while(CurrentGame.status !=  GameStatus.playerOwin) {
            
        //}
        
    }
    
    func playerMove(isPlayerX: Bool, coord: Int){

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
