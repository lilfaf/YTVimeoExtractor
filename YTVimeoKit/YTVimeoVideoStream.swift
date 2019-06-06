//
//  YTVimeoVideoStream.swift
//  YTVimeoKit
//
//  Created by Soneé John on 6/5/19.
//  Copyright © 2019 Louis Larpin. All rights reserved.
//

import Foundation

@objcMembers public class YTVimeoVideoStream: NSObject {
    
    public let url: URL
    public let size: NSSize
    
    internal init(url: URL, size: NSSize) {
        self.url = url
        self.size = size
    }
}
