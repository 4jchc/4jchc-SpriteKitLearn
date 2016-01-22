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
    
     var arrApple = [Apple]()
    
    
    //随机
    func createAppleRandom(){
        //随机度
        let midNum:UInt32 = arc4random()%4 + 1

        for var i:UInt32 = 0; i <= midNum; i++ {
            
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
        let y:CGFloat = CGFloat(arc4random()%200 + 200)
        apple.position  = CGPointMake(x , y)
        
        self.addChild(apple)
        arrApple.append(apple)

        
    }
    func move(speed:CGFloat){
        for apple in arrApple {
            apple.position.x -= speed
        }
        if arrApple.count > 0 && arrApple[0].position.x < -20{
            
            arrApple[0].removeFromParent()
            arrApple.removeAtIndex(0)
            
        }
        
    }
}
