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

class GameScene: SKScene,ProtocolMainScene {
    //懒加载
    lazy var panda = Panda()
    lazy var platformFactory = PlatformFactory()
    lazy var bg = BackGround()
    //移动速度
    var moveSpeed:CGFloat = 15
    
    var lastDis:CGFloat = 0.0


    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let skyColor = SKColor(red:113.0/255.0, green:197.0/255.0, blue:207.0/255.0, alpha:1.0)
        self.backgroundColor = skyColor

        // 添加背景
        self.addChild(bg)
        bg.zPosition=20
        
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
   
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        if panda.status == Status.run {
            panda.jump()
        }else if panda.status == Status.jump {
            panda.roll()
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        lastDis -= moveSpeed
        if lastDis <= 0 {
            print("生成新平台")
            //platformFactory.createPlatform(1, x: 1500, y: 200)
            platformFactory.createPlatformRandom()
        }
        // 移动平台
        platformFactory.move(self.moveSpeed)
        // 移动背景
        bg.move(moveSpeed/5)
    }
    
    func onGetData(dist:CGFloat){
        self.lastDis = dist
        
    }
}
