//
//  Apple.swift
//  05酷跑熊猫
//
//  Created by 蒋进 on 16/1/22.
//  Copyright © 2016年 蒋进. All rights reserved.
//

import UIKit
import SpriteKit
class Apple: SKNode {
    
    override init() {
        super.init()
        let appleTexture = SKTexture(imageNamed: "apple")
        let apple = SKSpriteNode(texture: appleTexture)
        apple.zPosition = 40
        apple.anchorPoint = CGPoint(x: 0,y: 0)
        self.addChild(apple)
        // 碰撞体 rectangle:长方形(矩形,直角)
        self.physicsBody = SKPhysicsBody(circleOfRadius: apple.frame.width/2, center: CGPointMake(0, 0))
        // 重力
        self.physicsBody!.dynamic = false
        // 角度
        self.physicsBody!.allowsRotation = false
        // 摩擦力
        self.physicsBody!.restitution = 0
        // 类别掩码(CategoryBitmask)
        self.physicsBody!.categoryBitMask = BitMaskType.apple
    
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
