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

    
    //宽
    var width :CGFloat = 0.0
    //高
    var height :CGFloat = 10.0
    
    //是否下沉
    var isDown = false
    
    func onCreate(arrSprite:[SKSpriteNode]){
        //通过接受SKSpriteNode数组来创建平台
        for platform in arrSprite {
            //以当前宽度为平台零件的x坐标
            platform.position.x = self.width
            //加载
            self.addChild(platform)
            //更新宽度
            self.width += platform.size.width
        }
        //当平台的零件只有三样，左中右时，设为会下落的平台
        if arrSprite.count<=3 {
            isDown = true
        }
        
        self.zPosition = 20
        //设置物理体为当前高宽组成的矩形
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.width, self.height),
            center: CGPointMake(self.width/2, 0))
        //设置物理标识
        self.physicsBody?.categoryBitMask = BitMaskType.platform
        //不响应响应物理效果
        self.physicsBody?.dynamic = false
        //不旋转
        self.physicsBody?.allowsRotation = false
        //弹性0
        self.physicsBody?.restitution = 0
    }

}
