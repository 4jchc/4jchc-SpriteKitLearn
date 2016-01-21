//
//  Platform平台.swift
//  05酷跑熊猫
//
//  Created by 蒋进 on 16/1/21.
//  Copyright © 2016年 蒋进. All rights reserved.
//

import UIKit
import SpriteKit
class Platform: SKNode {

    var width:CGFloat = 0.0
    var height:CGFloat = 10.0

    //通过节点数组创建平台
    func onCreate(arrSprite:[SKSpriteNode]){
        
        for platform in arrSprite {
            platform.position.x = self.width
            self.addChild(platform)
            self.width += platform.size.width
        }
    }
}
