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
    
    
    
    
    
    
    
    
    //MARK: -  添加妖怪
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
