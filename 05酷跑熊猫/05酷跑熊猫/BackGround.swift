//
//  BackGround.swift
//  05酷跑熊猫
//
//  Created by 蒋进 on 16/1/21.
//  Copyright © 2016年 蒋进. All rights reserved.
//

import UIKit
import SpriteKit
//继承自sknode
class BackGround :SKNode {
    //近处的背景数组
    var arrBG = [SKSpriteNode]()
    //远处树木的背景数组
    var arrFar = [SKSpriteNode]()
    //构造器
    override init() {
        //执行父类的构造器
        super.init()
        //远处背景的纹理
        let farTexture = SKTexture(imageNamed: "background_f1")
        //远处背景由3张无缝衔接的图组成
        let farBg0 = SKSpriteNode(texture: farTexture)
        farBg0.anchorPoint = CGPointMake(0, 0)
        //        farBg0.zPosition = 9
        farBg0.position.y = 150
        
        let farBg1 = SKSpriteNode(texture: farTexture)
        farBg1.anchorPoint = CGPointMake(0, 0)
        //        farBg1.zPosition = 9
        farBg1.position.x = farBg0.frame.width
        farBg1.position.y = farBg0.position.y
        
        let farBg2 = SKSpriteNode(texture: farTexture)
        farBg2.anchorPoint = CGPointMake(0, 0)
        //        farBg2.zPosition = 9
        farBg2.position.x = farBg0.frame.width * 2
        farBg2.position.y = farBg0.position.y
        
        self.addChild(farBg0)
        self.addChild(farBg1)
        self.addChild(farBg2)
        arrFar.append(farBg0)
        arrFar.append(farBg1)
        arrFar.append(farBg2)
        
        //近处背景纹理
        let texture = SKTexture(imageNamed: "background_f0")
        //近处背景由2张无缝衔接的图组成
        let bg0 = SKSpriteNode(texture: texture)
        bg0.anchorPoint = CGPointMake(0, 0)
        let bg1 = SKSpriteNode(texture: texture)
        bg1.anchorPoint = CGPointMake(0, 0)
        bg1.position.x = bg0.frame.width
        //        bg0.zPosition = 10
        //        bg1.zPosition = 10
        bg0.position.y = 70
        bg1.position.y = bg0.position.y
        self.addChild(bg0)
        self.addChild(bg1)
        arrBG.append(bg0)
        arrBG.append(bg1)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //移动函数
    func move(speed:CGFloat){
        //循环遍历近处背景，做x坐标位移
        for bg in arrBG {
            bg.position.x -= speed
        }
        //判断第一张背景图是否完全移除到场景外，如果移出去了，则整个近处背景图都归位
        if arrBG[0].position.x + arrBG[0].frame.width < speed {
            arrBG[0].position.x = 0
            arrBG[1].position.x = arrBG[0].frame.width
        }
        //循环遍历做远处背景，做x坐标位移
        for far in arrFar {
            far.position.x -= speed/4
        }
        //判断第一张背景图是否完全移除到场景外，如果移出去了，则整个远处背景图都归位
        if arrFar[0].position.x + arrFar[0].frame.width < speed/4 {
            arrFar[0].position.x = 0
            arrFar[1].position.x = arrFar[0].frame.width
            arrFar[2].position.x = arrFar[0].frame.width * 2
        }
    }
}
