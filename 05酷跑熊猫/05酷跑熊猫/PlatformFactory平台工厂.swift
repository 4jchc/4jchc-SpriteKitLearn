//
//  PlatformFactory平台工厂.swift
//  05酷跑熊猫
//
//  Created by 蒋进 on 16/1/21.
//  Copyright © 2016年 蒋进. All rights reserved.
//

import UIKit
import SpriteKit
//A定义代理.遵守协议.实现方法
//B继承代理,调用方法,传值
class PlatformFactory: SKNode {

    
    
    // 添加纹理图
    let textureLeft = SKTexture(imageNamed: "platform_l")
    let textureMid = SKTexture(imageNamed: "platform_m")
    let textureRight = SKTexture(imageNamed: "platform_r")
    // 平台数组
    var  platformsArray = [Platform]()

    var sceneWidth :CGFloat = 0
    // 子类实现代理
    var delegate:ProtocolMainScene?
    
    // 创建平台
    func createPlatform(midNum:UInt32,x:CGFloat,y:CGFloat){
        
        let platform = Platform()
        // 节点添加纹理图
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
        
         platformsArray.append(platform)
        //MARK:  代理执行方法
        //通用公式：平台的长度+x坐标 - 主场景的宽度
        delegate?.onGetData(platform.width + x - sceneWidth)
        
    }
    
    //随机
    func createPlatformRandom(){
        //随机平台的长度
        let midNum:UInt32 = arc4random()%4 + 1
        //随机间隔
        let gap:CGFloat = CGFloat(arc4random()%8 + 1)
        //x坐标
        let x:CGFloat = self.sceneWidth + CGFloat( midNum*50 ) + gap + 100
        //y坐标
        let y:CGFloat = CGFloat(arc4random()%200 + 200)
        
        createPlatform(midNum, x: x, y: y)
        
        
    }
    
    //移动--遍历数组然后移动平台位置
    func move(speed:CGFloat){
        // 遍历数组
        for p in  platformsArray{
            //x坐标的变化产生水平移动的动画
            p.position.x -= speed
        }
        // 移除平台
        if platformsArray.count > 0{
            
            if  platformsArray[0].position.x < -platformsArray[0].width {
                platformsArray[0].removeFromParent()
                platformsArray.removeAtIndex(0)
            }
        }

    }

}
