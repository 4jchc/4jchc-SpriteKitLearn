//
//  Apple.swift
//  05酷跑熊猫
//
//  Created by 蒋进 on 16/1/22.
//  Copyright © 2016年 蒋进. All rights reserved.
//

import UIKit
import SpriteKit
class Apple: SKNode {
    
    override init() {
        super.init()
        let appleTexture = SKTexture(imageNamed: "apple")
        let apple = SKSpriteNode(texture: appleTexture)
        apple.anchorPoint = CGPoint(x: 0,y: 0)
        self.addChild(apple)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
