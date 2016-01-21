//
//  BitMaskType.swift
//  05酷跑熊猫
//
//  Created by 蒋进 on 16/1/21.
//  Copyright © 2016年 蒋进. All rights reserved.
//

import UIKit
// 位掩码(BitMask)
class BitMaskType {
    class var panda:UInt32{
        return 1<<0
    }
    class var platform:UInt32{
        return 1<<1
    }
    class var apple:UInt32{
        return 1<<2
    }
    class var scene:UInt32{
        return 1<<3
    }
}