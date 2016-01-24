//
//  GameOverScen.swift
//  05酷跑熊猫
//
//  Created by 蒋进 on 16/1/23.
//  Copyright © 2016年 蒋进. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScen: SKScene {
    
    var message:String!
    var lable:SKLabelNode = SKLabelNode(fontNamed: "Chalkduster")
    var beginGame:SKLabelNode = SKLabelNode(fontNamed: "Chalkduster")
    var delegateMainScene:ProtocolMainScene?
    init(size: CGSize,won:Bool) {
        super.init(size: size)
        
        // 添加背景
        let skyColor = SKColor(red:113.0/255.0, green:197.0/255.0, blue:207.0/255.0, alpha:1.0)
        self.backgroundColor = skyColor
        
        // 设置提示信息
        if won{
            message = "You Won !"
        }else{
            message = "Game Over !"
        }
        lable.text = message
        lable.fontSize = 100
        lable.fontColor = SKColor.redColor()
        lable.position = CGPointMake(self.size.width/2, self.size.height/2)
        
        beginGame.text = "重新开始游戏"
        beginGame.fontSize = 50
        beginGame.fontColor = SKColor.wishesLilac()
        beginGame.position = CGPointMake(self.size.width/2, self.size.height/2-100)
        beginGame.name = "beginGame"
        self.addChild(beginGame)
        self.addChild(lable)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        //获取到用户
        for touch in touches {
            let location = touch.locationInNode(self)
            //取出用户点击的节点
            let node:SKNode = self.nodeAtPoint(location)
            if node.name == "beginGame"{
                
                print("点击重新开始游戏")
                // 添加转场特效
                let transition = SKTransition.doorsCloseVerticalWithDuration(0.5)
                //let scene = GameScene.init(size: self.size)
                let scene = GameScene(fileNamed:"GameScene")
                //MARK: 💗 必须加这个scaleMode因为加载时没有设置尺寸不像init
                scene!.scaleMode = .AspectFill
                self.view?.presentScene(scene!, transition: transition)
                

            }
            
        }
        
    }

    
    
    
    override func update(currentTime: NSTimeInterval) {
        

        beginGame.fontColor = SKColor.randomColorF()

        

    }
}
