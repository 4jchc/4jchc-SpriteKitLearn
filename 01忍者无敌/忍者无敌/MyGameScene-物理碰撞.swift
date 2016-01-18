//
//  MyGameScene-物理碰撞.swift
//  01忍者无敌
//
//  Created by 蒋进 on 16/1/18.
//  Copyright © 2016年 sijichcai. All rights reserved.
//

import UIKit
import SpriteKit

// 飞镖类别
let projectileCategory:UInt32 = 1 << 0;
// 妖怪类别
let monsterCategory:UInt32 = 1 << 1;


class MyGameScene2: SKScene ,SKPhysicsContactDelegate{
    
    
    //MARK: 💗---要让节点参与到物理仿真，必须设置该节点的物理刚体属性
    
    var _player:SKSpriteNode!
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // 0. 设置背景颜色
        self.backgroundColor = SKColor.whiteColor()
        // 定义物理仿真世界的属性(重力)
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
        self.physicsWorld.contactDelegate = self;
        
        // 1. 实例化忍者
        let player:SKSpriteNode = SKSpriteNode(imageNamed: "player")
        
        // 2. 设置忍者的位置
        player.position = CGPointMake(player.size.width / 2, self.size.height / 2);
        
        // 3. 将忍者添加场景中
        self.addChild(player)
        _player = player;
        
        // 4. 添加妖怪大军
        let addMonsterAction:SKAction = SKAction.runBlock{
            self.addMonster()
        }
        let wait = SKAction.waitForDuration(1.0)
        let sequence:SKAction = SKAction.sequence([addMonsterAction, wait])
        let repeat1:SKAction = SKAction.repeatActionForever(sequence)
        
        
        self.runAction(repeat1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    override func didMoveToView(view: SKView) {
        
        //        // 0. 设置背景颜色
        //        self.backgroundColor = SKColor.whiteColor()
        //        // 初始化数组
        //        _monsters = NSMutableArray()
        //        _projectiles = NSMutableArray()
        //
        //        // 1. 实例化忍者
        //        let player:SKSpriteNode = SKSpriteNode(imageNamed: "player")
        //
        //        // 2. 设置忍者的位置
        //        player.position = CGPointMake(player.size.width / 2, self.size.height / 2);
        //        // 3. 将忍者添加场景中
        //        self.addChild(player)
        //        _player = player;
        //
        //        // 4. 添加妖怪大军
        //        let addMonsterAction:SKAction = SKAction.runBlock{
        //            self.addMonster()
        //        }
        //        let wait = SKAction.waitForDuration(1.0)
        //        let sequence:SKAction = SKAction.sequence([addMonsterAction, wait])
        //        let repeat1:SKAction = SKAction.repeatActionForever(sequence)
        //
        //
        //        self.runAction(repeat1)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // 在SpriteKit中，默认就是支持多点触摸的
        for touch in touches {
            let location = touch.locationInNode(self)
            //添加飞镖
            self.addProjectile(location)
            // 播放音效
            self.runAction(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
        }
    }
    
    //MARK: - 物理仿真代理方法
    func didBeginContact(contact: SKPhysicsContact) {
        
        
        // 碰撞开始
        NSLog("碰撞开始");
        
        var monster:SKSpriteNode = SKSpriteNode()
        var projectile:SKSpriteNode = SKSpriteNode()
      
        
        // 根据类别位掩码获得飞镖和妖怪的节点
        if (contact.bodyA.categoryBitMask == projectileCategory) {
            projectile = contact.bodyA.node as! SKSpriteNode
            monster = contact.bodyB.node as! SKSpriteNode
        } else {
            projectile = contact.bodyB.node as! SKSpriteNode
            monster = contact.bodyA.node as! SKSpriteNode
        }
        
        // 将飞镖从场景中删除
        projectile.removeFromParent()
        // 将妖怪从场景中删除
        let rotate:SKAction = SKAction.rotateToAngle(CGFloat(-M_2_PI) , duration: 0.1)
        monster.runAction(rotate) { () -> Void in
            monster.removeFromParent()
        }

    }

    
    
    
    
    
    
    //MARK: - 私有方法添加飞镖
    ///  添加飞镖
    func addProjectile(location:CGPoint){
        // 1. 实例化飞镖
        let projectile:SKSpriteNode = SKSpriteNode(imageNamed: "projectile")
        // 1.2 设置飞镖的物理刚体属性
        // 1) 使用飞镖的尺寸创建一个圆形刚体
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width / 2.0)
        // 2) 标示物体的移动是否由仿真引擎负责
        projectile.physicsBody!.dynamic = true
        // 3) 设置类别掩码
        projectile.physicsBody!.categoryBitMask = projectileCategory;
        // 4) 设置碰撞检测类别掩码
        projectile.physicsBody!.contactTestBitMask = monsterCategory;
        // 5) 设置回弹掩码
        projectile.physicsBody!.collisionBitMask = 0;
        // 6) 设置精确检测，用在仿真运行速度较高的物体上，防止出现“遂穿”的情况
        projectile.physicsBody!.usesPreciseCollisionDetection = true
        
        
        
        
        
        // 2. 计算飞镖方向及速度
        // 2.1 计算飞镖的初始位置
        let from:CGPoint = CGPointMake(_player.size.width + projectile.size.width / 2.0, self.size.height / 2.0);
        // 2.2 计算目标位置
        // 1) x轴飞行的距离
        let x:CGFloat = self.size.width + projectile.size.width / 2.0 - from.x;
        // 2) 计算便宜点
        let offset:CGPoint = CGPointMake(location.x - from.x, location.y - from.y);
        // 3) 限制只允许向屏幕右侧发射飞镖
        if (offset.x <= 0){
            return
        }
        
        // 4) y轴计算飞行的距离
        let y:CGFloat = offset.y / offset.x * x + from.y;
        
        // 5) 生成目标飞行点
        let to:CGPoint = CGPointMake(x, y);
        
        // 3. 添加飞镖
        projectile.position = from;
        self.addChild(projectile)
        

        
        // 4. 设置飞镖的动作
        // 时间 = 距离 / 速度
        let p:CGPoint = CGPointMake(to.x - from.x, to.y - from.y);
        
        // 总飞行距离 算术平方根
        let distance:CGFloat = CGFloat(sqrtf(Float(p.x * p.x)  + Float(p.y * p.y)))
        // 飞镖飞行的速度(将场景的宽度作为速度，意味着如果是水平飞行，刚好一秒飞出屏幕)
        let volcity:CGFloat = self.size.width;
        let duration:NSTimeInterval =  Double(distance / volcity)
        let move:SKAction = SKAction.moveTo(to, duration: duration)

        projectile.runAction(move) { () -> Void in
            projectile.removeFromParent()
 
            
        }
    }
    
    
    
    //MARK: - 添加妖怪
    ///  添加妖怪
    func addMonster(){
        // 1. 实例化妖怪
        let monster:SKSpriteNode = SKSpriteNode(imageNamed: "monster")

        // 设置物理刚体属性
        // 1） 设置刚体形状
        monster.physicsBody = SKPhysicsBody(rectangleOfSize: monster.size)
        // 2) 标示物体的移动是否由仿真引擎负责
        monster.physicsBody!.dynamic = true
        // 3) 设置类别掩码
        monster.physicsBody!.categoryBitMask = monsterCategory;
        // 4) 设定能够与妖怪发生碰撞的物体的类别位掩码
        monster.physicsBody!.contactTestBitMask = projectileCategory;
        // 5) 设置回弹掩码
        monster.physicsBody!.collisionBitMask = 0;
        // 6) 设置精确检测，用在仿真运行速度较高的物体上，防止出现“遂穿”的情况
        monster.physicsBody!.usesPreciseCollisionDetection = true
        

        
        // 2. 设置妖怪的出现位置
        let x:CGFloat = self.size.width + monster.size.width / 2.0;
        let maxY:CGFloat = self.size.height - monster.size.height
        let randomY:CGFloat = (CGFloat(arc4random_uniform(UInt32(maxY))))
        let y:CGFloat = randomY + monster.size.height / 2.0;
        
        monster.position = CGPointMake(x, y);
        
        // 3. 添加妖怪
        self.addChild(monster)

        
        // 4. 让妖怪从右向左运动
        let duration:NSTimeInterval = (Double(arc4random_uniform((3))) + 2.0)
        let move:SKAction = SKAction.moveToX(-monster.size.width / 2.0 ,duration:duration)
        
        // 5. 让妖怪节点运行动作
        monster.runAction(move) { () -> Void in
            
            // 6. 从场景中删除妖怪
            monster.removeFromParent()

        }
        
    }
    

}
