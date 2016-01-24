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
        self.addChild(lable)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
