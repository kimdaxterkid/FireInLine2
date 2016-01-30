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
            }
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

