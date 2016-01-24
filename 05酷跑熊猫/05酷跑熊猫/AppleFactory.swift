//
//  AppleFactory.swift
//  05酷跑熊猫
//
//  Created by 蒋进 on 16/1/22.
//  Copyright © 2016年 蒋进. All rights reserved.
//

import UIKit
import SpriteKit
class AppleFactory: SKNode {
    
     var appleArray = [Apple]()
    
    
    // 随机Apple
    func createAppleRandom(){
        //随机度
        let midNum:UInt32 = arc4random()%1 + 1

        for var i:UInt32 = 0; i < midNum; i++ {
            
            createApple()
        }
    }

    
    func createApple(){
        
        let apple = Apple()
        //随机度
        let midNum:UInt32 = arc4random()%4 + 1
        //随机间隔
        let gap:CGFloat = CGFloat(arc4random()%8 + 1)
        //x坐标
        let x:CGFloat = UIScreen.mainScreen().bounds.size.width + CGFloat( midNum*50 ) + gap + 100
        //y坐标
        let y:CGFloat = CGFloat(arc4random()%400 + 200)
        apple.position  = CGPointMake(x , y)
        
        self.addChild(apple)
        appleArray.append(apple)

    }
    
    func move(speed:CGFloat){
        for apple in appleArray {
            apple.position.x -= speed
        }
        if appleArray.count > 0 && appleArray[0].position.x < -20{
            
            appleArray[0].removeFromParent()
            appleArray.removeAtIndex(0)
            
        }
    }
    
    
    //重置方法
    func reSet(){
        // 移除-动画-视图-清空数组
        self.removeAllActions()
        // 清除所有子对象
        self.removeAllChildren()
        // 清空平台数组
        appleArray.removeAll(keepCapacity: false)//保存容量
    }
    
}
