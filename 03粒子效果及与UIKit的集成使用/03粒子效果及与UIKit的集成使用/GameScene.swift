//
//  GameScene.swift
//  03粒子效果及与UIKit的集成使用
//
//  Created by 蒋进 on 16/1/17.
//  Copyright (c) 2016年 蒋进. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var _emitter:SKEmitterNode!
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        let path:NSString = NSBundle.mainBundle().pathForResource("MyParticle1", ofType: "sks")!
        let emitter:SKEmitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(path as String) as! SKEmitterNode
        emitter.position = CGPointMake(self.size.width / 2.0, self.size.height / 2.0);
        
        self.addChild(emitter)
        _emitter = emitter;

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
 
            _emitter.position = location

        }
        
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            _emitter.position = location
            
        }
    }
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
