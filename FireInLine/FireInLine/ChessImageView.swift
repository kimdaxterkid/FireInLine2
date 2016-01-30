//
//  ChessImageView.swift
//  FireInLine
//
//  Created by DavidKim on 16/1/30.
//  Copyright © 2016年 Taiwen Jin. All rights reserved.
//

import UIKit

class ChessImageView: UIImageView {

    var player:String?
    var activated:Bool! = false
    
    func setChess(_player:String) -> Void{
        self.player = _player
        if (activated == false) {
            if (_player == "black") {
                self.image = UIImage(named: "Black")

            }
            else {
                self.image = UIImage(named: "White")
            }
            activated = true
        }
    }

}
