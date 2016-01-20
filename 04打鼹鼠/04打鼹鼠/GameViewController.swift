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
    
    var gamescen:GameScene!
    @IBOutlet weak var start: UIButton!
    
    @IBAction func startG() {
        
        NSNotificationCenter.defaultCenter().postNotificationName("ChongXinKaiShi", object:nil,userInfo:nil)
        print("*****按钮发出通知")
        stackview.hidden = true
        
    }
    @IBOutlet weak var stackview: UIStackView!
    @IBOutlet weak var gameover: UILabel!
    
    
    
    // MARK: - 增加监听通知
    func stopGame(notification: NSNotification) {
        
        // 1.更换顶部区域item的文字
        let r = notification.userInfo?["_isGameOver"] as! Bool
        print("结束收到通知\(r)")
        if r == true{
            stackview.hidden = false
        }

    }
    
    deinit{
        // 通知在不需要的时候，要及时销毁
         NSNotificationCenter.defaultCenter().removeObserver(self, name: "tongzhi", object: nil)
        print("**\(super.classForCoder)--已销毁")
    }
    
    var _isStarted = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加通知监听，监听用户登录成功
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stopGame:", name: "tongzhi", object: nil)
        
    }
    
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let skView = self.view as! SKView
        
        //if !_isStarted{
        
        if skView.scene == nil{
            GameScene.loadSceneAssetsWithCompletionHandler({ () -> Void in
                
                //关闭显示器
                
                //创建和配置场景
                var scene = SKScene()
                if (IS_IPAD) {
                    //scene = GameScene_iPad(fileNamed:"GameScene")!
                    scene = GameScene_iPad.init(size: self.view.bounds.size)
                } else {
                    //scene = GameScene(fileNamed:"GameScene")!
                    scene = GameScene.init(size: self.view.bounds.size)
                }
                scene.scaleMode = .AspectFill
                //展现场景
                skView.presentScene(scene)
            })
            _isStarted = true
            //用于显示器
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.ignoresSiblingOrder = true
            
            //  }
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
