//
//  MessageSign.swift
//  Picturer
//
//  Created by Bob Huang on 16/3/23.
//  Copyright © 2016年 4view. All rights reserved.
//

import Foundation
import UIKit

class MessageSign: UIView {
    
    static var _self:MessageSign?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        
        if MessageSign._self ==  nil {
            MessageSign._self = self
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}