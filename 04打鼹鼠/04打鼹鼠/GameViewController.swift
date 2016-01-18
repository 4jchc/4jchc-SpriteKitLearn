//
//  GameViewController.swift
//  04打鼹鼠
//
//  Created by 蒋进 on 16/1/18.
//  Copyright (c) 2016年 蒋进. All rights reserved.
//

import UIKit
import SpriteKit
class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //let scene = GameScene(fileNamed:"GameScene")
       
            
   
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let skView = self.view as! SKView
        
        if skView.scene == nil{
            
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            let scene = GameScene.init(size: self.view.bounds.size)
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
            
        }
    }
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
