//
//  PlatformFactory平台工厂.swift
//  05酷跑熊猫
//
//  Created by 蒋进 on 16/1/21.
//  Copyright © 2016年 蒋进. All rights reserved.
//

import UIKit
import SpriteKit

class PlatformFactory: SKNode {
    
    //添加纹理图
    let textureLeft = SKTexture(imageNamed: "platform_l")
    let textureMid = SKTexture(imageNamed: "platform_m")
    let textureRight = SKTexture(imageNamed: "platform_r")
    //平台数组
    var platforms = [Platform]()
    
    //创建平台
    func createPlatform(midNum:UInt32,x:CGFloat,y:CGFloat){
        
        let platform = Platform()
        
        let platform_left = SKSpriteNode(texture: textureLeft)
        platform_left.anchorPoint = CGPointMake(0, 0.9)
        
        let platform_right = SKSpriteNode(texture: textureRight)
        platform_right.anchorPoint = CGPointMake(0, 0.9)
        
        var arrPlatform = [SKSpriteNode]()
        
        arrPlatform.append(platform_left)
        platform.position = CGPointMake(x, y)
        
        for _ in 1...midNum {
            
            let platform_mid = SKSpriteNode(texture: textureMid)
            platform_mid.anchorPoint = CGPointMake(0, 0.9)
            arrPlatform.append(platform_mid)
        }
        arrPlatform.append(platform_right)
        platform.onCreate(arrPlatform)
        self.addChild(platform)
        
        platforms.append(platform)
        
    }
    //移动平台--遍历平台数组然后移动平台位置
    func move(speed:CGFloat){
        for p in platforms{
            p.position.x -= speed
        }
    }

}
