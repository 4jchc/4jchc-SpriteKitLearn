//
//  GameScene.swift
//  04打鼹鼠
//
//  Created by 蒋进 on 16/1/18.
//  Copyright (c) 2016年 蒋进. All rights reserved.
//
import UIKit
import SpriteKit

class GameScene: SKScene {
    
    // 用来调整动画速度
    var steps = 0;
    // 根据分数来加速
    static var speed = 0;
    // 判断游戏结束
    var gameOverNum = 3;
    
    
    
    // 得分标签
    var _scoreLabel:SKLabelNode!
    // 用户得分
    var _score:Int = 0
    // 时钟标签
    var _timerLabel:SKLabelNode!
    // 游戏开始时间
    var _startTime:NSDate!
    // lose标签
    var _loseLabel:SKLabelNode!
    // lose计数
    var _lose:Int = 0
    // 游戏提示标签
    var _noteLabel:SKLabelNode!
    // 游戏结束
    var _isGameOver:Bool!
    
    //MARK: -  所有材质的静态变量，在加载材质方法中被设置
    static var sSharedDirtTexture:SKTexture = SKTexture()
    static var sSharedUpperTexture:SKTexture?
    static var sSharedLowerTexture:SKTexture?
    static var sSharedMoleTexture:SKTexture?
    
    static var sSharedMoleLaughFrames:[SKTexture] = []
    static var sSharedMoleThumpFrames:NSArray = NSArray()
    
    // 鼹鼠数组
    var _moles:NSArray!
    
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
        
        // 3. 得分标签
        
        _scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        _scoreLabel.text = "Score: 0";
        _scoreLabel.fontSize = kFontSize;
        //        let ScoreX:CGFloat = (IS_IPAD ? (20) : (20));
        //        let ScoreY:CGFloat = (IS_IPAD ? (80) : (20));
        //        _scoreLabel.position = CGPointMake(ScoreX, ScoreY);
        _scoreLabel.position = CGPointMake(20, 20);
        _scoreLabel.zPosition = 4;
        _scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left;
        
        self.addChild(_scoreLabel)
        
        
        // 4. 计时标签
        
        _timerLabel = SKLabelNode(fontNamed: "Academy Engraved LET")
        _timerLabel.text = "00:00:00";
        _timerLabel.fontSize = kFontSize
        _timerLabel.zPosition = 4;
        //        let timerX:CGFloat  = (IS_IPAD ? (self.size.width - 160) : (self.size.width - 20));
        //        let timerY:CGFloat  = (IS_IPAD ? (self.size.height - 30 - 160) : (self.size.height - kFontSize - 20));
        //        _timerLabel.position = CGPointMake(timerX, timerY);
        
        _timerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right;
        _timerLabel.position = CGPointMake(self.size.width - 20, self.size.height - kFontSize - 20);
        self.addChild(_timerLabel)
        
        //5.添加lose标签
        
        _loseLabel = SKLabelNode(fontNamed: "Chalkduster")
        _loseLabel.text = "Lose: 0";
        _loseLabel.fontSize = kFontSize;
        _loseLabel.fontColor = SKColor.redColor()
        let loseX:CGFloat   = (IS_IPAD ? (260) : (90));
        let loseY:CGFloat   = (IS_IPAD ? (20) : (20));
        _loseLabel.position = CGPointMake(loseX, loseY);
        // _loseLabel.position = CGPointMake(99, 20);
        _loseLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left;
        _loseLabel.zPosition = 4;
        
        self.addChild(_loseLabel)
        // 添加通知监听
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "newStart", name: "ChongXinKaiShi", object: nil)
        
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
        startGame()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startGame(){
        
        setupUI()
        loadMoles()
        setupMoles()
        //记录游戏开始时间
        _startTime = NSDate()
        //游戏标识符
        _isGameOver = false
        
        
    }
    
    func newStart(){
        loadMoles()
        setupMoles()
        _scoreLabel.text = "Score: 0";
        _timerLabel.text = "00:00:00";
        _loseLabel.text = "Lose: 0";
        _startTime = NSDate()
        _isGameOver = false
        
        
    }
    func stopGame(){
        for var i:Int = 0; i < 3; i++ {
            
            (_moles[i] as! Mole).stopAction()
        }
        
        // 通知在不需要的时候，要及时销毁
        //NSNotificationCenter.defaultCenter().removeObserver(self, name: "tongzhi", object: nil)
    }
    
    func isGameOver(){
        if (_lose == gameOverNum) {
            //记录游戏开始时间
            _startTime = NSDate()
            //得分
            _score = 0;
            //lose计数
            _lose = 0;
            self.stopGame()
            _isGameOver = true
            let tongzhi = "tongzhi"
            NSNotificationCenter.defaultCenter().postNotificationName(tongzhi, object:nil,userInfo: ["_isGameOver":_isGameOver])
        }
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        
        
        //当游戏结束时停止更新时钟
        if (_isGameOver == true) {
            
            return
        }
        //获取到用户打到鼹鼠
        for touch in touches {
            let location = touch.locationInNode(self)
            //取出用户点击的节点
            let node:SKNode = self.nodeAtPoint(location)
            if node.name == "mole"{
                
                let mole = node as! Mole
                mole.thumped()
                
                _score += 10;
                _scoreLabel.text = NSString(format: "Score: %d", _score) as String
                
            }else{
                _lose++;
                _loseLabel.text = NSString(format: "Lose: %d", _lose) as String
                
                self.isGameOver()
                
            }
        }
    }
    //MARK: -  屏幕每次刷新时调用，在SpriteKit中不需要自行指定时钟
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        steps++;
        //当游戏结束时停止更新时钟
        if (_isGameOver == true) {
            
            return
        }
        
        // 更新时钟标签
        let dt:Int = Int(NSDate().timeIntervalSinceDate(_startTime))
        _timerLabel.text = NSString(format: "%02d:%02d:%02d", dt / 3600, (dt % 3600) / 60, dt % 60) as String
        
        
        var seed:Int = (20 - _score / 2)
        seed = (seed > 5) ? seed : 5;
        if (steps % seed == 0) {
            
            let num:Int = (Int(arc4random_uniform(UInt32(3))))
            let mole:Mole = _moles[num] as! Mole
            mole.moveUpDown()
            
        }
    }
    //MARK: - 由于游戏开发中，素材经常会发生变化，因此加载素材的方法，最好单独使用一个方法完成，这样便于应用程序的维护
    ///  真正的加载素材的方法
    //类方法-多线程加载素材(static的类方法.属性也要是static)
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
                //因为回调函数涉及到实例化场景以及展现，因此需要在主线程执行
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    NSLog("实例化场景2： %@", NSThread.currentThread());
                    callback!();
                })
            }
        }
    }
    
    
    deinit{
        // 通知在不需要的时候，要及时销毁
        NSNotificationCenter.defaultCenter().removeObserver(self)
        print("**\(super.classForCoder)--已销毁")
    }
    
}




