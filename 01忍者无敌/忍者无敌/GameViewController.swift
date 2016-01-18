//
//  GameViewController.swift
//  忍者无敌
//
//  Created by 蒋进 on 16/1/15.
//  Copyright (c) 2016年 sijichcai. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
class GameViewController: UIViewController {
    var _bgMusicPlayer:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. 实例化播放背景音乐
        let url:NSURL = NSBundle.mainBundle().URLForResource("background-music-aac", withExtension: "caf")!
        
        _bgMusicPlayer = try! AVAudioPlayer.init(contentsOfURL: url)
        //准备播放
        _bgMusicPlayer.prepareToPlay()
        //循环播放
        _bgMusicPlayer.numberOfLoops = -1;
        
        _bgMusicPlayer.play()
        //        if let scene = GameScene(fileNamed:"GameScene") {
        //
        //            // 1. 配置SKView
        //            let skView = self.view as! SKView
        //            // 以下两个属性用于在开发过程中跟踪使用，应用发布时需要取消
        //            // 显示屏幕刷新率(帧/秒)
        //
        //            skView.showsFPS = true
        //            // 显示当前场景中的节点数量
        //            skView.showsNodeCount = true
        //            NSLog("%s - %@", __FUNCTION__, NSStringFromCGSize(self.view.bounds.size));
        //
        //            /* Sprite Kit applies additional optimizations to improve rendering performance */
        //            //精灵套件适用于额外的优化，以提高渲染性能
        //            skView.ignoresSiblingOrder = true
        //
        //            /* Set the scale mode to scale to fit the window */
        //            /** 设置缩放模式以适应窗口 */
        //            // 2. 创建和配置场景
        //            scene.scaleMode = .AspectFill
        //            // 3. 展现场景
        //            skView.presentScene(scene)
        //        }
    }
    
    
    //MARK: - 此方法是接收到UIWindow传递的设备旋转消息，准备调整视图中所有子视图图布局时调用
    // 注意：viewDidAppear方法是视图完成显示后执行，如果此时才去加载视图中的游戏部分的内容
    // 会造成系统响应的延迟，影响用户体验！
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // 1. 配置SKView
        let skView = self.view as! SKView
        
        // 2. 判断场景是否已经存在
        if ((skView.scene == nil)) {
            // 以下两个属性用于在开发过程中跟踪使用，应用发布时需要取消
            // 显示屏幕刷新率(帧/秒)
            skView.showsFPS = true
            // 显示当前场景中的节点数量
            skView.showsNodeCount = true
            NSLog("%s - %@", __FUNCTION__, NSStringFromCGSize(self.view.bounds.size));
            
            // 2. 创建和配置场景
            //let scene = GameScene(fileNamed:"GameScene")
            let scene = MyGameScene2.init(size: skView.bounds.size)
            scene.scaleMode = SKSceneScaleMode.AspectFill;
            
            // 3. 展现场景
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
    
    //MARK:  - 隐藏状态栏
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
    
}
