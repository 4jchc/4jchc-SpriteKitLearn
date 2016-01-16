//
//  MyGameScene.swift
//  忍者无敌
//
//  Created by 蒋进 on 16/1/15.
//  Copyright © 2016年 sijichcai. All rights reserved.
//

import UIKit
import SpriteKit
class MyGameScene: SKScene {
    
    
    var _player:SKSpriteNode!
    // 妖怪数组
    
    var _monsters:NSMutableArray!
    // 飞镖数组
    var _projectiles:NSMutableArray!
    
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // 0. 设置背景颜色
        self.backgroundColor = SKColor.whiteColor()
        // 初始化数组
        _monsters = NSMutableArray()
        _projectiles = NSMutableArray()
        
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
    
    //MARK: - 私有方法添加飞镖
    ///  添加飞镖
    func addProjectile(location:CGPoint){
        // 1. 实例化飞镖
        let projectile:SKSpriteNode = SKSpriteNode(imageNamed: "projectile")
    
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

        _projectiles.addObject(projectile)
        
        // 4. 设置飞镖的动作
        // 时间 = 距离 / 速度
        let p:CGPoint = CGPointMake(to.x - from.x, to.y - from.y);
        
        // 总飞行距离 算术平方根
        let distance:CGFloat = CGFloat(sqrtf(Float(p.x * p.x)  + Float(p.y * p.y)))
        // 飞镖飞行的速度(将场景的宽度作为速度，意味着如果是水平飞行，刚好一秒飞出屏幕)
        let volcity:CGFloat = self.size.width;
        let duration:NSTimeInterval =  Double(distance / volcity)
        let move:SKAction = SKAction.moveTo(to, duration: duration)
        
        weak var weakSelf = self
        projectile.runAction(move) { () -> Void in
            projectile.removeFromParent()
            weakSelf?._projectiles.removeObject(projectile)

        }
    }
    
    
    
    //MARK: - 添加妖怪
    ///  添加妖怪
    func addMonster(){
        // 1. 实例化妖怪
        let monster:SKSpriteNode = SKSpriteNode(imageNamed: "monster")
        
        // 2. 设置妖怪的出现位置
        let x:CGFloat = self.size.width + monster.size.width / 2.0;
        let maxY:CGFloat = self.size.height - monster.size.height
        let randomY:CGFloat = (CGFloat(arc4random_uniform(UInt32(maxY))))
        let y:CGFloat = randomY + monster.size.height / 2.0;
        
        monster.position = CGPointMake(x, y);
        
        // 3. 添加妖怪
        self.addChild(monster)
        _monsters.addObject(monster)
        
        // 4. 让妖怪从右向左运动
        let duration:NSTimeInterval = (Double(arc4random_uniform((3))) + 2.0)
        let move:SKAction = SKAction.moveToX(-monster.size.width / 2.0 ,duration:duration)
        
        // 5. 让妖怪节点运行动作
        weak var weakSelf = self
        weakSelf?._monsters.removeObject(monster)
        monster.runAction(move) { () -> Void in
            
            // 6. 从场景中删除妖怪
            monster.removeFromParent()
            weakSelf?._monsters.removeObject(monster)
        }
    
    }
}
