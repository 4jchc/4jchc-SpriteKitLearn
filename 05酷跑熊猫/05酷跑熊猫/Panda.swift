//
//  Panda.swift
//  05酷跑熊猫
//
//  Created by 蒋进 on 16/1/21.
//  Copyright © 2016年 蒋进. All rights reserved.
//

import UIKit
//05酷跑熊猫-02添加素材
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
    
    let jumpAtlas = SKTextureAtlas(named: "jump.atlas")
    var jumpFrames = [SKTexture]()
    
    let rollAtlas = SKTextureAtlas(named: "roll.atlas")
    var rollFrames = [SKTexture]()
    
     var status = Status.run
    
    
    init(){
        //单个纹理图
        let texture = runAtlas.textureNamed("panda_run_01")
        let size = texture.size()
        super.init(texture: texture, color: SKColor.whiteColor(), size: size)
        
        //MARK: - 跑---遍历纹理图集-得到单个纹理图-添加到纹理图集数组
        for var i = 1; i<=runAtlas.textureNames.count; i++ {
            let tempName = String(format: "panda_run_%.2d", i)
            let runTexture = runAtlas.textureNamed(tempName)
            
            
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
        status = .jump
        self.runAction(SKAction.animateWithTextures(jumpFrames, timePerFrame: 0.05))
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
