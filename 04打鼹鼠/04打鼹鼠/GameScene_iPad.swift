//
//  GameScene_iPad.swift
//  04打鼹鼠
//
//  Created by 蒋进 on 16/1/19.
//  Copyright © 2016年 蒋进. All rights reserved.
//

import UIKit

class GameScene_iPad: GameScene {
    
    //MARK: - 设置鼹鼠的位置
    ///  设置鼹鼠的位置
    override func setupMoles() {

            
            let holeOffset:CGFloat = 310
            let startPoint:CGPoint = CGPointMake(self.size.width / 2 - holeOffset, self.size.height / 2 - 150)
            
            _moles.enumerateObjectsUsingBlock { (mole, idex, strop) -> Void in
                
                let p:CGPoint = CGPointMake(startPoint.x +  CGFloat(idex) * holeOffset, startPoint.y);
                let mole = mole as! Mole
                mole.position = p
                mole.zPosition = 1;
                mole.hiddenY = p.y;
                self.addChild(mole)
            }

    }
}
