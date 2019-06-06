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
    public let isSourceStream: Bool
    
    internal init(url: URL, size: NSSize, isSourceStream: Bool = false) {
        self.url = url
        self.size = size
        self.isSourceStream = isSourceStream
    }
}
