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
            GameScene.loadSceneAssetsWithCompletionHandler({ () -> Void in
                
                //关闭显示器
                skView.ignoresSiblingOrder = true
                //创建和配置场景
                let scene = GameScene.init(size: self.view.bounds.size)
                scene.scaleMode = .AspectFill
                //展现场景
                skView.presentScene(scene)
            })

            //用于显示器
            skView.showsFPS = true
            skView.showsNodeCount = true
            

            
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
