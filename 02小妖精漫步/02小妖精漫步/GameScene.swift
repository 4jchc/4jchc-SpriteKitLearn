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
    var _goblin:SKSpriteNode?
    
    /**
     1. 添加发呆的小妖精
     2. 点击屏幕，让小妖精转身
     3. 让小妖精匀速走到手指点击的位置
     1) 停止发呆（删除掉发呆的动画）
     2) 开始走路动画
     3) 计算行走的距离和时间
     
     */
     //MARK: - 加载纹理图集
     ///  加载纹理图集
    func loadAltasFrames(atlasName:String,prefix:String,count:Int)->NSArray{
        
        // 1. 实例化纹理图集
        let atlas:SKTextureAtlas = SKTextureAtlas(named: atlasName)
        
        // 2. 新建纹理数组
        let arrayM:NSMutableArray = NSMutableArray(capacity: count)

        for var i:Int = 1; i <= count; i++ {
            
            let fileName:NSString = NSString(format: "%@_%04d", prefix,i)
            let texture:SKTexture = atlas.textureNamed(fileName as String)
            arrayM.addObject(texture)
        }
        
            return arrayM;
    }
    //MARK: - goblin小妖精执行序列帧动画
    ///  goblin小妖精执行序列帧动画
    func goblinRepeatActionWith(array:NSArray){
        
        let action:SKAction = SKAction.animateWithTextures(array as! [SKTexture], timePerFrame: 0.1)
        _goblin!.runAction(SKAction.repeatActionForever(action))

    }
    
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        // 1. 实例化纹理图集
        _idleFrames = self.loadAltasFrames("Goblin_Idle", prefix: "goblin_idle", count: 28)
        _walkFrames = self.loadAltasFrames("Goblin_Walk", prefix: "goblin_walk", count: 28)
        
        // 3. 实例化小妖精精灵
        let goblin:SKSpriteNode = SKSpriteNode(texture: _idleFrames![0] as? SKTexture)
        goblin.position = CGPointMake(self.size.width / 2, self.size.height / 2);
        self.addChild(goblin)
        _goblin = goblin
        
        // 4. 让小妖精发呆动画
        self.goblinRepeatActionWith(_idleFrames!)

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        // 让妖精转身
        // 1. 获取点击的位置
        
        let touch:UITouch = (touches as NSSet).anyObject() as! UITouch
        
        // 获取当前的位置
        let location:CGPoint = touch.locationInNode(self)
        // 2. 计算偏移量
        let offset:CGPoint = CGPointMake(location.x - _goblin!.position.x, location.y - _goblin!.position.y)
        
        // 3. 计算角度 = y / x
        let angle:CGFloat = CGFloat(atan2f(Float(offset.y) , Float(offset.x)))

        // 4. 设置角度
        _goblin!.zRotation = angle - CGFloat(M_PI_2)
        
        // 5. 计算行走距离和时间 平方根Square root
        let distance:CGFloat = CGFloat(sqrtf(Float(offset.x * offset.x)  + Float(offset.y * offset.y)))
        let volcity:CGFloat = self.size.height / 2
        let duration:NSTimeInterval = Double(distance / volcity)
        
        
        // 6. 设置小妖精的动画
        // 1) 删除发呆动画
        _goblin!.removeAllActions()
        
        // 2) 添加行走动画
        self.goblinRepeatActionWith(_walkFrames!)
        
        // 3) 添加移动动画
        let move:SKAction = SKAction.moveTo(location, duration: duration)
        
        // 4) 移动完成恢复发呆状态
        
        weak var weakSelf = self
        
       
        _goblin?.runAction(move, completion: { () -> Void in
            
             weakSelf?._goblin?.removeAllActions()
             weakSelf?.goblinRepeatActionWith(weakSelf!._idleFrames!)
        })
        
  
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
