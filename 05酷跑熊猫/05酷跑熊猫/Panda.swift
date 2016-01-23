//
//  Panda.swift
//  05酷跑熊猫
//
//  Created by 蒋进 on 16/1/21.
//  Copyright © 2016年 蒋进. All rights reserved.
//

import UIKit
//🐻酷跑熊猫-03定义跑，跳，滚动等动作动画
import SpriteKit

enum Status :Int{
    case run = 1, jump, jump2,roll
}

class Panda: SKSpriteNode {
    
    
    
    //定义跑，跳，滚动等动作动画
    //添加纹理图集
    let runAtlas = SKTextureAtlas(named: "run.atlas")
    //纹理图集数组
    var runFrames = [SKTexture]()
    
    //添加纹理图集
    let jumpAtlas = SKTextureAtlas(named: "jump.atlas")
    var jumpFrames = [SKTexture]()
    
    //添加纹理图集
    let rollAtlas = SKTextureAtlas(named: "roll.atlas")
    var rollFrames = [SKTexture]()
    
    //起跳特效纹理集
    let jumpEffectAtlas = SKTextureAtlas(named: "jump_effect.atlas")
    //存储起跳特效纹理的数组
    var jumpEffectFrames = [SKTexture]()
    //起跳特效
    var jumpEffect = SKSpriteNode()
    
    
    var status = Status.run
    
    // 记录熊猫跳的距离
    // 起跳 y坐标
    var jumpStart:CGFloat = 0.0
    // 落地 y坐标
    var jumpEnd:CGFloat = 0.0
    
    init(){
        //单个纹理图
        let texture = runAtlas.textureNamed("panda_run_01")
        let size = texture.size()
        super.init(texture: texture, color: SKColor.whiteColor(), size: size)
        
        //MARK: - 跑---遍历纹理图集-得到单个纹理图-添加到纹理图集数组
        for var i = 1; i<=runAtlas.textureNames.count; i++ {
            
            // 1.得到单个纹理图
            let tempName = String(format: "panda_run_%.2d", i)
            let runTexture = runAtlas.textureNamed(tempName)
            
            // 2.添加到纹理图集数组
            runFrames.append(runTexture)
            
        }
        //跳
        for var i = 1; i<=jumpAtlas.textureNames.count; i++ {
            
            let tempName = String(format: "panda_jump_%.2d", i)
            let jumpTexture = jumpAtlas.textureNamed(tempName)
            
            
            jumpFrames.append(jumpTexture)
            
        }
        //滚
        for var i = 1; i<=rollAtlas.textureNames.count; i++ {
            let tempName = String(format: "panda_roll_%.2d", i)
            let rollTexture = rollAtlas.textureNamed(tempName)
            
            
            rollFrames.append(rollTexture)
            
        }
        //起跳特效
        for var i = 1 ; i <= jumpEffectAtlas.textureNames.count ; i++ {
            let tempName = String(format: "jump_effect_%.2d", i)
            let effectexture = jumpEffectAtlas.textureNamed(tempName)

                jumpEffectFrames.append(effectexture)
        
        }
        //设置起跳特效
        jumpEffect = SKSpriteNode(texture: jumpEffectFrames[0])
        jumpEffect.position = CGPointMake(-80, -30)
        jumpEffect.hidden = true
        self.addChild(jumpEffect)

        
        // 碰撞体
        self.physicsBody = SKPhysicsBody(rectangleOfSize:texture.size())
        // 重力
        self.physicsBody!.dynamic = true
        // 角度
        self.physicsBody!.allowsRotation = false
        // 摩擦力
        self.physicsBody!.restitution = 0
        // 类别掩码(CategoryBitmask)
        self.physicsBody!.categoryBitMask = BitMaskType.panda
        // 接触掩码（ContactTestBitmask）
        self.physicsBody!.contactTestBitMask = BitMaskType.scene | BitMaskType.platform | BitMaskType.apple
        // 碰撞掩码(CollisionBitmask),
        self.physicsBody!.collisionBitMask = BitMaskType.platform

        run()
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func run(){
        //清楚所有动作
        self.removeAllActions()
        self.status = .run
        //重复跑动动作
        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(runFrames, timePerFrame: 0.05)))
    }
    
    func jump (){
        self.removeAllActions()
        
        if status != Status.jump2 {
            self.runAction(SKAction.animateWithTextures(jumpFrames, timePerFrame: 0.05))
            self.physicsBody!.velocity = CGVectorMake(0, 450)
            if status == Status.jump {
                status = Status.jump2
                // 记录开始跳的点
                self.jumpStart = self.position.y;
            }else{
                // 显示特效
                showJumpEffect()
                status = Status.jump
            }
        }
    }
    
    
    
    //起跳特效
    func showJumpEffect(){
        //先将特效取消隐藏
        jumpEffect.hidden = false
        //利用action播放特效
        let action = SKAction.animateWithTextures( jumpEffectFrames, timePerFrame: 0.05)
        //执行闭包，再次隐藏特效
        let removeAction = SKAction.runBlock({() in
            self.jumpEffect.hidden = true
        })
        //组成序列Action进行执行(先显示，后隐藏)
        jumpEffect.runAction(SKAction.sequence([action,removeAction]))
        
    }
    func roll(){
        self.removeAllActions()
        status = .roll
        self.runAction(SKAction.animateWithTextures(rollFrames, timePerFrame: 0.05),completion:{
            () in
            self.run()
        })
    }
}
