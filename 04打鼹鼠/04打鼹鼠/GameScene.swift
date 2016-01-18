//
//  GameScene.swift
//  04打鼹鼠
//
//  Created by 蒋进 on 16/1/18.
//  Copyright (c) 2016年 蒋进. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var _scoreLabel:SKLabelNode!
    var _score:Int!
    var _timerLabel:SKLabelNode!
    var _startTime:NSDate!
    
    
    var sSharedDirtTexture:SKTexture?
    var sSharedUpperTexture:SKTexture?
    var sSharedLowerTexture:SKTexture?
    var sSharedMoleTexture:SKTexture?
    
    var sSharedMoleLaughFrames:NSArray?
    var sSharedMoleThumpFrames:NSArray?
    
    // 鼹鼠数组
    var moles:NSArray!
    
    
    //MARK: - 私有方法
    
    //MARK: - 设置UI布局
    ///  设置UI布局
    func setupUI(){
        // 0. 场景中心点
        let center:CGPoint = CGPointMake(self.size.width / 2.0, self.size.height / 2.0);
        
        // 1. 添加背景
        //添加纹理图集
        let altas:SKTextureAtlas = SKTextureAtlas.atlasWithName("background")
        //单个纹理图
        let dirtTexture:SKTexture = altas.textureNamed("bg_dirt")
        //节点加载单个纹理图
        let dirt:SKSpriteNode = SKSpriteNode(texture: dirtTexture)
        dirt.position = center
        // 放大比例
        dirt.setScale(2.0)
        self.addChild(dirt)
        
        // 2. 添加前景
        // 2.1 上面的草
        //添加纹理图集
        let foreAltas:SKTextureAtlas = SKTextureAtlas.atlasWithName("foreground")
        //单个纹理图
        let upperTexture:SKTexture = foreAltas.textureNamed("grass_upper")
        //节点加载单个纹理图
        let upper:SKSpriteNode = SKSpriteNode(texture: upperTexture)
        //锚点
        upper.anchorPoint = CGPointMake(0.5, 0.0);
        upper.position = center;
        self.addChild(upper)
    
        
        
        // 2.2 下面的草
        //单个纹理图
        let lowerTexture:SKTexture = foreAltas.textureNamed("grass_lower")
        //节点加载单个纹理图
        let lower:SKSpriteNode = SKSpriteNode(texture: lowerTexture)
        //锚点
        lower.anchorPoint = CGPointMake(0.5, 1.0);
        lower.position = center;

        self.addChild(lower)
       
    }

    
    override init(size: CGSize) {
        super.init(size: size)
        setupUI()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
//    override func didMoveToView(view: SKView) {
//        setupUI()
//    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
