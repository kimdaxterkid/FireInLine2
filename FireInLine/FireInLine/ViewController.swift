//
//  ViewController.swift
//  FireInLine
//
//  Created by DavidKim on 16/1/30.
//  Copyright © 2016年 Taiwen Jin. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate {
    var appDelegate:AppDelegate!
    var currentPlayer:String!
    @IBOutlet var fields: [ChessImageView]!
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        appDelegate.mpcHandler.setupPeerWithDisplayName(UIDevice.currentDevice().name)
        appDelegate.mpcHandler.setupSession()
        appDelegate.mpcHandler.advertiseSelf(true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "peerChangedStateWithNotification:", name: "MPC_DidChangeStateNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handlerReceivedDataWithNotification:", name: "MPC_DidReceiveDataNotification", object: nil)
        setField()
        currentPlayer = "black"
    }
    func peerChangedStateWithNotification(notification:NSNotification) {
        let userInfo = NSDictionary(dictionary: notification.userInfo!)
        let state = userInfo.objectForKey("state") as! Int
        if (state != MCSessionState.Connecting.rawValue) {
            self.navigationItem.title = "Connected"
        }
    }
    
    func handlerReceivedDataWithNotification(notification:NSNotification) {
        let userInfo = notification.userInfo! as Dictionary
        let receivedData:NSData = userInfo["data"] as! NSData
        do {
            let message = try NSJSONSerialization.JSONObjectWithData(receivedData, options: NSJSONReadingOptions.AllowFragments)
            let senderPeerID:MCPeerID = userInfo["peerID"] as! MCPeerID
            let senderDisplayName = senderPeerID.displayName
            if (message.objectForKey("string")?.isEqualToString("New Game") == true){
                let alert = UIAlertController(title: "TicTacToe", message: "\(senderDisplayName) has started a new Game", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                resetField()
            }else{
                let field:Int? = message.objectForKey("field")?.integerValue
                let player:String? = message.objectForKey("player") as? String
                if (field != nil && player != nil) {
                    fields[field!].player = player
                    fields[field!].setChess(player!)
                    if (player == "black") {
                        currentPlayer = "white"
                    }
                    else {
                        currentPlayer = "black"
                    }
                    checkResults()
                }
            }
        } catch {
            print(error)
        }
    }
    @IBAction func newGame(sender: AnyObject) {
        resetField()
        let messageDict = ["string":"New Game"]
        do {
            let messageData = try NSJSONSerialization.dataWithJSONObject(messageDict, options: NSJSONWritingOptions.PrettyPrinted)
            try appDelegate.mpcHandler.session.sendData(messageData, toPeers: appDelegate.mpcHandler.session.connectedPeers, withMode: MCSessionSendDataMode.Reliable)
        } catch {
            print(error)
        }

    }
    @IBAction func connectWithPlayer(sender: AnyObject) {
        if appDelegate.mpcHandler.session != nil {
            appDelegate.mpcHandler.setupBrowser()
            appDelegate.mpcHandler.browswer.delegate = self
            self.presentViewController(appDelegate.mpcHandler.browswer, animated: true, completion: nil)
        }
    }
    
    func fieldTapped(recognizer:UITapGestureRecognizer){
        let tappedField = recognizer.view as! ChessImageView
        tappedField.setChess(currentPlayer);
        let messageDict = ["field":tappedField.tag, "player":currentPlayer]
        do {
            let messageData = try NSJSONSerialization.dataWithJSONObject(messageDict, options: NSJSONWritingOptions.PrettyPrinted)
            try appDelegate.mpcHandler.session.sendData(messageData, toPeers: appDelegate.mpcHandler.session.connectedPeers, withMode: MCSessionSendDataMode.Unreliable)
            checkResults()
        } catch {
            print(error)
        }
    }
    
    func setField() {
        for index in 0 ... fields.count - 1 {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: "fieldTapped:")
            gestureRecognizer.numberOfTapsRequired = 1
            fields[index].addGestureRecognizer(gestureRecognizer)
        }
    }
    func resetField(){
        for index in 0 ... fields.count - 1{
            fields[index].image = nil
            fields[index].activated = false
            fields[index].player = ""
        }
        
        currentPlayer = "black"
    }
    func checkResults(){
        var winner = ""
        if fields[0].player == "black" && fields[1].player == "black" && fields[2].player == "black" && fields[3].player == "black"{
            winner = "black"
        }else if fields[0].player == "white" && fields[1].player == "white" && fields[2].player == "white" && fields[3].player == "white"{
            winner = "white"
        }else if fields[4].player == "black" && fields[5].player == "black" && fields[6].player == "black" && fields[7].player == "black"{
            winner = "black"
        }else if fields[4].player == "white" && fields[5].player == "white" && fields[6].player == "white" && fields[7].player == "white"{
            winner = "white"
        }else if fields[8].player == "black" && fields[9].player == "black" && fields[10].player == "black" && fields[11].player == "black"{
            winner = "black"
        }else if fields[8].player == "white" && fields[9].player == "white" && fields[10].player == "white" && fields[11].player == "white"{
            winner = "white"
        }else if fields[12].player == "black" && fields[13].player == "black" && fields[14].player == "black" && fields[15].player == "black"{
            winner = "black"
        }else if fields[12].player == "white" && fields[13].player == "white" && fields[14].player == "white" && fields[15].player == "white"{
            winner = "white"
        }else if fields[0].player == "black" && fields[4].player == "black" && fields[8].player == "black" && fields[12].player == "black"{
            winner = "black"
        }else if fields[0].player == "white" && fields[4].player == "white" && fields[8].player == "white" && fields[12].player == "white"{
            winner = "white"
        }else if fields[1].player == "black" && fields[5].player == "black" && fields[9].player == "black" && fields[13].player == "black"{
            winner = "black"
        }else if fields[1].player == "white" && fields[5].player == "white" && fields[9].player == "white" && fields[13].player == "white"{
            winner = "white"
        }else if fields[2].player == "black" && fields[6].player == "black" && fields[10].player == "black" && fields[14].player == "black"{
            winner = "black"
        }else if fields[2].player == "white" && fields[6].player == "white" && fields[10].player == "white" && fields[14].player == "white"{
            winner = "white"
        }else if fields[3].player == "black" && fields[7].player == "black" && fields[11].player == "black" && fields[15].player == "black"{
            winner = "black"
        }else if fields[3].player == "white" && fields[7].player == "white" && fields[11].player == "white" && fields[15].player == "white"{
            winner = "white"
        }else if fields[0].player == "black" && fields[5].player == "black" && fields[10].player == "black" && fields[15].player == "black"{
            winner = "black"
        }else if fields[0].player == "white" && fields[5].player == "white" && fields[10].player == "white" && fields[15].player == "white"{
            winner = "white"
        }else if fields[3].player == "black" && fields[6].player == "black" && fields[9].player == "black" && fields[12].player == "black"{
            winner = "x"
        }else if fields[3].player == "white" && fields[6].player == "white" && fields[9].player == "white" && fields[12].player == "white"{
            winner = "white"
        }
        
        if winner != ""{
            let alert = UIAlertController(title: "FireInLine", message: "The winner is \(winner)", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
                self.resetField()
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browswer.dismissViewControllerAnimated(true, completion: nil)
    }
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browswer.dismissViewControllerAnimated(true, completion: nil)
    }
}

