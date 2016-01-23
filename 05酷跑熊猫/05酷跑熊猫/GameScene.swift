//
//  GameScene.swift
//  05酷跑熊猫
//
//  Created by 蒋进 on 16/1/21.
//  Copyright (c) 2016年 蒋进. All rights reserved.
//

import SpriteKit

protocol ProtocolMainScene{
    func onGetData(dist:CGFloat)
}

class GameScene: SKScene,ProtocolMainScene,SKPhysicsContactDelegate {
    
    var apple:Apple!
    //懒加载
    lazy var panda = Panda()
    lazy var platformFactory = PlatformFactory()
    lazy var bg = BackGround()
    lazy var appleFactory = AppleFactory()
    lazy var loadSound = LoadSound()
    //移动速度
    var moveSpeed:CGFloat = 15
    //判断最后一个平台还有多远完全进入游戏场景
    var lastDis:CGFloat = 0.0
    

    //碰撞检测函数
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody = contact.bodyA.categoryBitMask
        let secondBody = contact.bodyB.categoryBitMask
        let maskBody = firstBody | secondBody
        
        
        // 如果熊猫和场景边缘碰撞
        if maskBody == BitMaskType.scene | BitMaskType.panda{
            
//            self.runAction(SKAction.sequence([SKAction.waitForDuration(1),SKAction.runBlock({
//            
//
//            })]))
            // 添加转场特效
            let transition = SKTransition.doorsCloseVerticalWithDuration(0.5)
            let scene = GameOverScen.init(size: self.size, won: false)
            self.view?.presentScene(scene, transition: transition)
            // 游戏结束
            moveSpeed = 0
            
//            // 移除-动画-视图-清空数组
//            platformFactory.removeAllActions()
//            platformFactory.removeAllChildren()
//            platformFactory.platformsArray.removeAll(keepCapacity: true)//保存容量
//            
//            // 移除-动画-视图-清空数组
//            appleFactory.removeAllActions()
//            appleFactory.removeAllChildren()
//            appleFactory.appleArray.removeAll(keepCapacity: true)//保存容量
            
            loadSound.stopBackgroundMusic()
            
        }
        
        
        // 熊猫和台子碰撞
        if maskBody == (BitMaskType.platform | BitMaskType.panda){
            panda.run()
            
            panda.jumpEnd = panda.position.y
            // 判断熊猫跳的距离执行翻滚动作
            if panda.jumpEnd-panda.jumpStart <= -30 {
                panda.roll()
            }
            
        }
        // 熊猫和苹果碰撞
        if maskBody == BitMaskType.apple | BitMaskType.panda {
            
            if firstBody == BitMaskType.apple{
                apple = contact.bodyA.node as! Apple
            }
            if secondBody == BitMaskType.apple {
                
                apple = contact.bodyB.node as! Apple
            }
            loadSound.playEat()
            apple.removeFromParent()
        }
        
        
    }

    func didEndContact(contact: SKPhysicsContact){
        //记录距离
        panda.jumpStart = panda.position.y
        
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let skyColor = SKColor(red:113.0/255.0, green:197.0/255.0, blue:207.0/255.0, alpha:1.0)
        self.backgroundColor = skyColor

        // 添加背景
        self.addChild(bg)
        bg.zPosition=20
        
        //MARK: 一定要加载音乐类SKNode
        self.addChild( loadSound )
        loadSound.playBackgroundMusic()
        
        // 设置物理碰撞代理
        self.physicsWorld.contactDelegate = self
        // 重力
        self.physicsWorld.gravity = CGVectorMake(0, -5)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody!.categoryBitMask = BitMaskType.scene
        // 产生碰撞后重力不会飞来飞去
        self.physicsBody!.dynamic = false
        
        
        // 添加熊猫
        panda.position = CGPointMake(200, 400)
        panda.zPosition=40
        self.addChild(panda)
        
        // 添加平台
        self.addChild(platformFactory)
        platformFactory.zPosition=30
        platformFactory.sceneWidth = self.frame.size.width
        platformFactory.delegate = self
        platformFactory.createPlatform(3, x: 0, y: 200)
        
        // 添加苹果
        //appleFactory.createAppleRandom()
        self.addChild( appleFactory )
   
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        if panda.status == Status.run {
            panda.jump()
        }else if panda.status == Status.jump {
            panda.roll()
        }
        
    }
    // 每一桢 执行一次
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        lastDis -= moveSpeed
        if lastDis <= 0 {
            print("生成新平台")
            //platformFactory.createPlatform(1, x: 1500, y: 200)
            platformFactory.createPlatformRandom()
            appleFactory.createAppleRandom()
        }
        // 移动平台
        platformFactory.move(self.moveSpeed)
        appleFactory.move(self.moveSpeed)
        // 移动背景
        bg.move(moveSpeed/5)
    }
    
    func onGetData(dist:CGFloat){
        self.lastDis = dist
        
    }
}
