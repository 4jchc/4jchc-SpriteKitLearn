//
//  GameScene.swift
//  04打鼹鼠
//
//  Created by 蒋进 on 16/1/18.
//  Copyright (c) 2016年 蒋进. All rights reserved.
//

import SpriteKit
//多线程加载素材实现鼹鼠笑动画及声音
class GameScene: SKScene {
    
    var _scoreLabel:SKLabelNode!
    var _score:Int!
    var _timerLabel:SKLabelNode!
    var _startTime:NSDate!
    
    
   static var sSharedDirtTexture:SKTexture = SKTexture()
   static var sSharedUpperTexture:SKTexture?
   static var sSharedLowerTexture:SKTexture?
   static var sSharedMoleTexture:SKTexture?
    
   static var sSharedMoleLaughFrames:[SKTexture] = []
   static var sSharedMoleThumpFrames:NSArray = NSArray()
    
    // 鼹鼠数组
    var _moles:NSArray!
    //var Mole:SKSpriteNode!
    
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
//        //添加纹理图集
//        let altas:SKTextureAtlas = SKTextureAtlas.atlasWithName("background")
//        //单个纹理图
//        let dirtTexture:SKTexture = altas.textureNamed("bg_dirt")
        
        //节点加载单个纹理图
        let dirt:SKSpriteNode = SKSpriteNode(texture: GameScene.sSharedDirtTexture)
        
        dirt.position = center
        // 放大比例
        dirt.setScale(2.0)
        self.addChild(dirt)
        
        // 2. 添加前景
        // 2.1 上面的草
//        //添加纹理图集
//        let foreAltas:SKTextureAtlas = SKTextureAtlas.atlasWithName("foreground")
//        //单个纹理图
//        let upperTexture:SKTexture = foreAltas.textureNamed("grass_upper")
        //节点加载单个纹理图
        let upper:SKSpriteNode = SKSpriteNode(texture: GameScene.sSharedUpperTexture)
        //锚点
        upper.anchorPoint = CGPointMake(0.5, 0.0);
        upper.position = center;
        self.addChild(upper)
        
        
        
        // 2.2 下面的草
        //单个纹理图
//        let lowerTexture:SKTexture = foreAltas.textureNamed("grass_lower")
        //节点加载单个纹理图
        let lower:SKSpriteNode = SKSpriteNode(texture: GameScene.sSharedLowerTexture)
        //锚点
        lower.anchorPoint = CGPointMake(0.5, 1.0);
        lower.position = center;
        lower.zPosition = 2
        self.addChild(lower)
        
    }
    
    
    
    
    //MARK: - 加载鼹鼠
    ///  加载鼹鼠
    func loadMoles(){
        
//        // 1. 添加鼹鼠纹理图集
//        let foreAltas:SKTextureAtlas = SKTextureAtlas.atlasWithName("sprites")
//        //单个纹理图
//        let texture:SKTexture = foreAltas.textureNamed("mole_1")
        
        // 2. 创建鼹鼠精灵并添加至数组
        let arrayM:NSMutableArray = NSMutableArray(capacity: 3)
        for _ in 0..<3 {
            //节点加载单个纹理图
            let mole:Mole = Mole.moleWithTexture(GameScene.sSharedMoleTexture!, laughFrames: GameScene.sSharedMoleLaughFrames, thumpFrames: GameScene.sSharedMoleThumpFrames)
            
         
            arrayM.addObject(mole)
        }
        
        
        _moles = arrayM;
    }
    
    //MARK: - 设置鼹鼠的位置
    ///  设置鼹鼠的位置
    func setupMoles(){
        
        let holeOffset:CGFloat = 155;
        let startPoint:CGPoint = CGPointMake(self.size.width / 2 - holeOffset, self.size.height / 2 - 70)
        
        _moles.enumerateObjectsUsingBlock { (mole, idex, strop) -> Void in
            
            let p:CGPoint = CGPointMake(startPoint.x +  CGFloat(idex) * holeOffset, startPoint.y);
            let mole = mole as! Mole
            mole.position = p
            mole.zPosition = 1;
            mole.hiddenY = p.y;
            self.addChild(mole)
        }
    
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
  

                for touch in touches {
                    let location = touch.locationInNode(self)
                    let node:SKNode = self.nodeAtPoint(location)
                    if node.name == "mole"{
                    
                        let mole = node as! Mole
                        mole.thumped()
                    }
                    
//                    let sprite = SKSpriteNode(imageNamed:"Spaceship")
//        
//                    sprite.xScale = 0.5
//                    sprite.yScale = 0.5
//                    sprite.position = location
//        
//                    let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//        
//                    sprite.runAction(SKAction.repeatActionForever(action))
//        
//                    self.addChild(sprite)
                }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        steps++;
        
        
        if (steps % 30 == 0) {
            
            let num:Int = (Int(arc4random_uniform(UInt32(3))))
            let mole:Mole = _moles[num] as! Mole
            mole.moveUpDown()
            
        }
    }
    //MARK: - 类方法-多线程加载素材(static的类方法.属性也要是static)
    ///  实际的素材加载方法
    static func loadSceneAssets(){
    
        NSThread.sleepForTimeInterval(0.2)
        NSLog("实例化场景1： %@", NSThread.currentThread());
        
        // 1. 加载背景
        //添加纹理图集
        let backgroundAtlas:SKTextureAtlas = SKTextureAtlas.atlasWithName("background")
        //单个纹理图
        sSharedDirtTexture = backgroundAtlas.textureNamed("bg_dirt")
        
        // 2. 上面的草
        //添加纹理图集
        let foregroundAtlas:SKTextureAtlas = SKTextureAtlas.atlasWithName("foreground")
        //单个纹理图
        sSharedUpperTexture = foregroundAtlas.textureNamed("grass_upper")
        
        //TODO:
        // 3. 下面的草
        //单个纹理图
        sSharedLowerTexture = foregroundAtlas.textureNamed("grass_lower")
        
        // 4. 鼹鼠
        // 1. 添加鼹鼠纹理图集
        let moleAtlas:SKTextureAtlas = SKTextureAtlas.atlasWithName("sprites")
        // 2. 单个纹理图
        sSharedMoleTexture = moleAtlas.textureNamed("mole_1")
        
        
        // 5. 鼹鼠笑的数组
        sSharedMoleLaughFrames = [moleAtlas.textureNamed("mole_laugh1"),
                        moleAtlas.textureNamed("mole_laugh2"),
                        moleAtlas.textureNamed("mole_laugh3")
        ]

        // 6. 鼹鼠挨打的数组
        sSharedMoleThumpFrames = [moleAtlas.textureNamed("mole_thump1"),
                        moleAtlas.textureNamed("mole_thump2"),
                        moleAtlas.textureNamed("mole_thump3"),
                        moleAtlas.textureNamed("mole_thump4")
        ]


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




