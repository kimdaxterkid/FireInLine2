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
    @IBOutlet var fields: [ChessImageView]!
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        appDelegate.mpcHandler.setupPeerWithDisplayName("2232")
        appDelegate.mpcHandler.setupSession()
        appDelegate.mpcHandler.advertiseSelf(true)
    }
    @IBAction func connectWithPlayer(sender: AnyObject) {
        if appDelegate.mpcHandler.session != nil {
            appDelegate.mpcHandler.setupBrowser()
            appDelegate.mpcHandler.browswer.delegate = self
            self.presentViewController(appDelegate.mpcHandler.browswer, animated: true, completion: nil)
        }
    }
    func setGameLogic() {
        for index in 0...fields.count-1 {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: "fieldTapped")
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

