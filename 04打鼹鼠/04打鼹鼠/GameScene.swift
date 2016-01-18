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
    var _moles:NSArray!
    var Mole:SKSpriteNode!
    
    var steps:Int = 0
    
    
    /// 1.定义闭包
    typealias AssetLoadCompletionHandler = () -> Void
    
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
        lower.zPosition = 2
        self.addChild(lower)
        
    }
    
    
    
    
    //MARK: - 加载鼹鼠
    ///  加载鼹鼠
    func loadMoles(){
        
        // 1. 添加鼹鼠纹理图集
        let foreAltas:SKTextureAtlas = SKTextureAtlas.atlasWithName("sprites")
        //单个纹理图
        let texture:SKTexture = foreAltas.textureNamed("mole_1")
        
        // 2. 创建鼹鼠精灵并添加至数组
        let arrayM:NSMutableArray = NSMutableArray(capacity: 3)
        for var i:Int = 0; i <= 3; i++ {
            
            
        }
        
        for _ in 0..<3 {
            //节点加载单个纹理图
            let mole:SKSpriteNode = SKSpriteNode(texture: texture)
            
            arrayM.addObject(mole)
        }
        
        
        _moles = arrayM;
    }
    
    //MARK: - 设置鼹鼠的位置
    ///  设置鼹鼠的位置
    func setupMoles(){
        
        let holeOffset:CGFloat = 155;
        let startPoint:CGPoint = CGPointMake(self.size.width / 2 - holeOffset, self.size.height / 2 - 75);
        
        _moles.enumerateObjectsUsingBlock { (mole, idex, strop) -> Void in
            
            let p:CGPoint = CGPointMake(startPoint.x +  CGFloat(idex) * holeOffset, startPoint.y);
            let mole = mole as! SKSpriteNode
            mole.position = p
            
            //mole.hiddenY = p.y;
            mole.zPosition = 1;
            self.addChild(mole)
        }
        
    }
    
    
    
    //MARK: - 鼹鼠动画，先向上出现，停留0.5秒后，再隐藏
    ///  鼹鼠动画，先向上出现，停留0.5秒后，再隐藏
    func moveUpWithMole(mole:SKSpriteNode){
        
        if (self.hasActions()) {
            
            return
        }
        let moveUp:SKAction = SKAction.moveToY(mole.position.y + mole.size.height, duration:0.2)
        
        moveUp.timingMode = SKActionTimingMode.EaseInEaseOut//SKActionTiming.EaseOut;
        let moveDown:SKAction = SKAction.moveToY(mole.position.y, duration: 0.2)
        moveDown.timingMode = SKActionTimingMode.EaseInEaseOut
        let delay:SKAction = SKAction.waitForDuration(0.5)
        let sequence:SKAction = SKAction.sequence([moveUp, delay, moveDown])
        
        
        mole.runAction(sequence)
    }
    
    
    override init(size: CGSize) {
        super.init(size: size)
        setupUI()
        loadMoles()
        setupMoles()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //    override func didMoveToView(view: SKView) {
    //    //        setupUI()
    //    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        //        for touch in touches {
        //            let location = touch.locationInNode(self)
        //
        //            let sprite = SKSpriteNode(imageNamed:"Spaceship")
        //
        //            sprite.xScale = 0.5
        //            sprite.yScale = 0.5
        //            sprite.position = location
        //
        //            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        //
        //            sprite.runAction(SKAction.repeatActionForever(action))
        //
        //            self.addChild(sprite)
        //        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        steps++;
        
        
        if (steps % 30 == 0) {
            
            let num:Int = (Int(arc4random_uniform(UInt32(3))))
            self.moveUpWithMole(_moles[num] as! SKSpriteNode)
            
        }
    }
    //MARK: - 类方法
    ///  实际的素材加载方法
    static func loadSceneAssets(){
        NSThread.sleepForTimeInterval(0.2)
        NSLog("实例化场景1： %@", NSThread.currentThread());
    }
    
    /**
     *  加载场景需要使用的素材
     *
     *  @param callback 回调方法
     */
     //MARK: - 加载场景需要使用的素材
    static func loadSceneAssetsWithCompletionHandler(callback:AssetLoadCompletionHandler?){
        
        
        let queue:dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
         let weakSelf = self
        
        
        dispatch_async(queue) { () -> Void in
            //处理耗时操作的代码块...
            weakSelf.loadSceneAssets()
            if callback != nil{
                
                //操作完成，调用主线程来刷新界面
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    NSLog("实例化场景2： %@", NSThread.currentThread());
                    callback!();
                })
            }
            
        }
    
    }
}




