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
    //跑了多远变量
    var distance :CGFloat = 0.0
    //最大速度
    var maxSpeed :CGFloat = 100.0
    //移动速度
    var moveSpeed:CGFloat = 15
    //判断最后一个平台还有多远完全进入游戏场景
    var lastDis:CGFloat = 0.0

    //是否game over
    var isLose = false
    
    //碰撞检测函数
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody = contact.bodyA.categoryBitMask
        let secondBody = contact.bodyB.categoryBitMask
        let maskBody = firstBody | secondBody
        
        
        // 如果熊猫和场景边缘碰撞
        if maskBody == BitMaskType.scene | BitMaskType.panda{
            
            self.runAction(SKAction.sequence([SKAction.waitForDuration(1),SKAction.runBlock({
            
                // 添加转场特效
                let transition = SKTransition.doorsCloseVerticalWithDuration(0.5)
                let scene = GameOverScen.init(size: self.size, won: false)
                self.view?.presentScene(scene, transition: transition)
            })]))

            // 游戏结束
            moveSpeed = 0
            loadSound.playDead()
            //会在updata时判断是否结束游戏
            isLose = true
            loadSound.stopBackgroundMusic()
            
            
   
            
        }
        
        
        // 熊猫和台子碰撞
        if maskBody == (BitMaskType.platform | BitMaskType.panda){
            
            //假设平台不会下沉，用于给后面判断平台是否会被熊猫震的颤抖
            var isDown = false
            //用于判断接触平台后能否转变为跑的状态，默认值为false不能转换
            var canRun = false
            //如果碰撞体A是平台
            if contact.bodyA.categoryBitMask == BitMaskType.platform {
                
                //如果是会下沉的平台
                if (contact.bodyA.node as! Platform).isDown {
                    isDown = true
                    //让平台接收重力影响
                    contact.bodyA.node?.physicsBody?.dynamic = true
                    //不将碰撞效果取消，平台下沉的时候会跟着熊猫跑这不是我们希望看到的，
                    //大家可以将这行注释掉看看效果
                    contact.bodyA.node?.physicsBody?.collisionBitMask = 0
                    //如果是会升降的平台
                }
                
                if contact.bodyB.node?.position.y > contact.bodyA.node!.position.y {
                    canRun=true
                }
            //如果碰撞体B是平台
            }else if contact.bodyB.categoryBitMask == BitMaskType.platform  {
                if (contact.bodyB.node as! Platform).isDown {
                    contact.bodyB.node?.physicsBody?.dynamic = true
                    contact.bodyB.node?.physicsBody?.collisionBitMask = 0
                    isDown = true
                }
                if contact.bodyA.node?.position.y > contact.bodyB.node?.position.y {
                    canRun=true
                }
            }
            
            
            
            
            //  判断是否打滚
            panda.jumpEnd = panda.position.y

            // 判断熊猫跳的距离执行翻滚动作
            if panda.jumpEnd-panda.jumpStart <= -70 {
                panda.roll()
                //如果平台下沉就不让它被震得颤抖一下
                if !isDown {
                    downAndUp(contact.bodyA.node!)
                    downAndUp(contact.bodyB.node!)
                }
            }else{
                if canRun {
                    panda.run()
                }
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
        
        if isLose {
            reSet()
        }else{
            panda.jump()
        }
        
//        if panda.status == Status.run {
//            panda.jump()
//        }else if panda.status == Status.jump {
//            panda.roll()
//        }
        
    }
    // 每一桢 执行一次
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        //如果小人出现了位置偏差，就逐渐恢复
        if panda.position.x < 200 {
            let x = panda.position.x + 1
            panda.position = CGPointMake(x, panda.position.y)
        }
        if !isLose {
            lastDis -= moveSpeed
            //速度以5为基础，以跑的距离除以2000为增量
            var tempSpeed = CGFloat(5 + Int(distance/2000))
            //将速度控制在maxSpeed
            if tempSpeed > maxSpeed {
                tempSpeed = maxSpeed
            }
            //如果移动速度小于新的速度就改变
            if moveSpeed < tempSpeed {
                moveSpeed = tempSpeed
            }
            
            if lastDis <= 0 {
                print("生成新平台")
                //platformFactory.createPlatform(1, x: 1500, y: 200)
                platformFactory.createPlatformRandom()
                appleFactory.createAppleRandom()
            }
            // 移动平台
            platformFactory.move(self.moveSpeed)
            // 移动苹果
            appleFactory.move(self.moveSpeed)
            // 移动背景
            bg.move(moveSpeed/5)
            // 累加速度成距离
            distance += moveSpeed
        }
        

    }
    
    //重新开始游戏
    func reSet(){
        //重置isLose变量
        isLose = false
        //重置小人位置
        panda.position = CGPointMake(200, 400)
        //重置移动速度
        moveSpeed  = 15.0
        //重置跑的距离
        distance = 0.0
        //重置首个平台完全进入游戏场景的距离
        lastDis = 0.0
        //平台工厂的重置方法
        platformFactory.reSet()
        //苹果工厂的重置方法
        appleFactory.reSet()
        //创建一个初始的平台给熊猫一个立足之地
        platformFactory.createPlatform(3, x: 0, y: 200)
        //一定要加载音乐类SKNode
        loadSound.playBackgroundMusic()
        
        
    }
    //up and down 方法(平台震动一下)
    func downAndUp(node :SKNode,down:CGFloat = -50,downTime:Double=0.05,
        up:CGFloat=50,upTime:Double=0.1){
            //下沉动作
            let downAct = SKAction.moveByX(0, y: down, duration: downTime)
            //上升动过
            let upAct = SKAction.moveByX(0, y: up, duration: upTime)
            //下沉上升动作序列
            let downUpAct = SKAction.sequence([downAct,upAct])
            node.runAction(downUpAct)
    }
    
    func onGetData(dist:CGFloat){
        self.lastDis = dist
        
    }
}
