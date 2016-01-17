//
//  GameScene.swift
//  02小妖精漫步
//
//  Created by 蒋进 on 16/1/17.
//  Copyright (c) 2016年 蒋进. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var _idleFrames:NSArray?
    var _walkFrames:NSArray?
    /**
     1. 添加发呆的小妖精
     2. 点击屏幕，让小妖精转身
     3. 让小妖精匀速走到手指点击的位置
     1) 停止发呆（删除掉发呆的动画）
     2) 开始走路动画
     3) 计算行走的距离和时间
     
     */
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // 1. 实例化纹理图集
        let altas:SKTextureAtlas = SKTextureAtlas(named: "Goblin_Idle")
        
        // 2. 新建纹理数组
        let arrayM:NSMutableArray = NSMutableArray(capacity: 28)
        for var i:Int = 1; i <= 29; i++ {

            let fileName:NSString = NSString(format: "goblin_idle_%04d", i)
            let texture:SKTexture = altas.textureNamed(fileName as String)
            arrayM.addObject(texture)
        }
        _idleFrames = arrayM
        
        // 3. 实例化小妖精精灵
        let goblin:SKSpriteNode = SKSpriteNode(texture: _idleFrames![0] as? SKTexture)
        goblin.position = CGPointMake(self.size.width / 2, self.size.height / 2);
        
        self.addChild(goblin)
        // 4. 让小妖精发呆动画
        let action:SKAction = SKAction.animateWithTextures(_idleFrames as! [SKTexture], timePerFrame: 0.1)
        goblin.runAction(SKAction.repeatActionForever(action))
    

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
