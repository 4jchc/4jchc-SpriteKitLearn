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
    /** 鼹鼠出洞动画组 */
    var laughAction:SKAction!
    /** 鼹鼠被打动画组 */
    var thumpAction:SKAction!
    /** 被打了标记 */
    var beThumped = false
    /** 隐藏时的Y值 */
    var hiddenY = CGFloat()
    
    
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
        
        mole.name = "mole"
        return mole
    }
    
    
    
    //MARK: - 鼹鼠动画，先向上出现，停留0.5秒后，再隐藏
    ///  鼹鼠动画，先向上出现，停留0.5秒后，再隐藏
    func moveUpDown(){
        
        if (self.hasActions()) {
            
            return
        }
        let moveUp:SKAction = SKAction.moveToY(self.hiddenY + self.size.height, duration:0.2)
        moveUp.timingMode = SKActionTimingMode.EaseInEaseOut//SKActionTiming.EaseOut;
        
        let moveDown:SKAction = SKAction.moveToY(self.hiddenY, duration: 0.2)//self.position.y
        moveDown.timingMode = SKActionTimingMode.EaseInEaseOut
        
        let delay:SKAction = SKAction.waitForDuration(0.5)
        let sequence:SKAction = SKAction.sequence([moveUp,self.laughAction, delay, moveDown])
        
        
        self.runAction(sequence)
    
    }
    
    
    
    //MARK: -  鼹鼠被打了
    ///   鼹鼠被打了
    func thumped(){
        
        if (self.beThumped)  {return}
        self.beThumped = true
        
        // 1. 删除所有操作
        self.removeAllActions()
        
        // 2. 定义向下移动的动画
        let moveDown:SKAction = SKAction.moveToY(self.hiddenY, duration: 0.2)
        
        moveDown.timingMode = SKActionTimingMode.EaseInEaseOut
        let sequence:SKAction = SKAction.sequence([self.thumpAction,moveDown])
        self.runAction(sequence) { () -> Void in
            
            self.beThumped = false
        }
        
    }
    //MARK: - 停止鼹鼠动画
    ///  停止鼹鼠动画
    func stopAction(){
        
        // 1. 删除所有操作
        self.removeAllActions()
        self.removeFromParent()
    }

    
}
