//
//  LoadSound.swift
//  05酷跑熊猫
//
//  Created by 蒋进 on 16/1/23.
//  Copyright © 2016年 蒋进. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
class LoadSound: SKNode {
    var bgMusicPlayer = AVAudioPlayer()
    // 加载跳的声音动作
    let jumpAct = SKAction.playSoundFileNamed("jump_from_platform.mp3", waitForCompletion: false)
    // 加载死的声音动作
    let loseAct = SKAction.playSoundFileNamed("lose.mp3", waitForCompletion: false)
    // 加载滚的声音动作
    let rollAct = SKAction.playSoundFileNamed("hit_platform.mp3", waitForCompletion: false)
    // 加载吃的声音动作
    let eatAct = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false)
    
    func playBackgroundMusic(){
        
        // 获取apple.mp3文件地址
        let bgMusicURL:NSURL =  NSBundle.mainBundle().URLForResource("apple", withExtension: "mp3")!
        // 根据背景音乐地址生成播放器
        bgMusicPlayer = try! AVAudioPlayer(contentsOfURL: bgMusicURL)
        // 设置为循环播放
        bgMusicPlayer.numberOfLoops = -1
        // 准备播放音乐
        bgMusicPlayer.prepareToPlay()
        // 播放音乐
        bgMusicPlayer.play()
    }
    func stopBackgroundMusic(){
        if bgMusicPlayer.playing{
            bgMusicPlayer.stop()
        }
    }
    
    func playDead(){
        self.runAction(loseAct)
    }
    func playJump(){
        self.runAction(jumpAct)
    }
    func playRoll(){
        self.runAction(rollAct)
    }
    func playEat(){
        self.runAction(eatAct)
    }
}
