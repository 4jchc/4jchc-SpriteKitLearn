//
//  Mole.swift
//  04打鼹鼠
//
//  Created by 蒋进 on 16/1/19.
//  Copyright © 2016年 蒋进. All rights reserved.
//

import UIKit
import SpriteKit

class Mole: SKSpriteNode {
    
    var laughAction:SKAction!
    
    var thumpAction:SKAction!
    
    
    //MARK: - 使用材质实例化鼹鼠
    ///  使用材质实例化鼹鼠
    //   static func moleWithTexture(texture:SKTexture)->Mole{
    //
    //        //节点加载单个纹理图
    //        let mole:Mole = Mole(texture: texture)
    //        mole.zPosition = 1
    //        return mole
    //    }
    static func moleWithTexture(texture:SKTexture,laughFrames:NSArray, thumpFrames:NSArray)->Mole{
        
        // 节点加载单个纹理图
        let mole:Mole = Mole(texture: texture)
        // 设置层次
        mole.zPosition = 1
        
        // 笑动作
        let laugh:SKAction = SKAction.animateWithTextures(laughFrames as! [SKTexture] , timePerFrame: 0.1)
        let laughSound:SKAction = SKAction.playSoundFileNamed("laugh.caf", waitForCompletion: false)
        mole.laughAction = SKAction.group([laugh, laughSound])
        
        // 捶击(重击)动作
        let thump:SKAction = SKAction.animateWithTextures(thumpFrames as! [SKTexture] , timePerFrame: 0.1)
        let thumpSound:SKAction = SKAction.playSoundFileNamed("ow.caf", waitForCompletion: false)
        mole.thumpAction = SKAction.group([thump, thumpSound])
        
        

        return mole
    }
    
    
    
    
    
    
    
    //MARK: - 鼹鼠动画，先向上出现，停留0.5秒后，再隐藏
    ///  鼹鼠动画，先向上出现，停留0.5秒后，再隐藏
    func moveUp(){
        
        if (self.hasActions()) {
            
            return
        }
        let moveUp:SKAction = SKAction.moveToY(self.position.y + self.size.height, duration:0.2)
        
        moveUp.timingMode = SKActionTimingMode.EaseInEaseOut//SKActionTiming.EaseOut;
        let moveDown:SKAction = SKAction.moveToY(self.position.y, duration: 0.2)
        moveDown.timingMode = SKActionTimingMode.EaseInEaseOut
        let delay:SKAction = SKAction.waitForDuration(0.5)
        let sequence:SKAction = SKAction.sequence([moveUp,self.laughAction, delay, moveDown])
        
        
        self.runAction(sequence)
    }
}
