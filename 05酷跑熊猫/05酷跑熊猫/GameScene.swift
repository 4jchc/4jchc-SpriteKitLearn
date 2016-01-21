//
//  GameScene.swift
//  05酷跑熊猫
//
//  Created by 蒋进 on 16/1/21.
//  Copyright (c) 2016年 蒋进. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
        lazy var panda  = Panda()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let skyColor = SKColor(red:113.0/255.0, green:197.0/255.0, blue:207.0/255.0, alpha:1.0)
        self.backgroundColor = skyColor
        panda.position = CGPointMake(200, 400)
        self.addChild(panda)


    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        

    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
