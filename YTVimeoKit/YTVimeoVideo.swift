//
//  YTVimeoVideo.swift
//  YTVimeoKit
//
//  Created by Soneé John on 6/3/19.
//  Copyright © 2019 Louis Larpin. All rights reserved.
//

import Cocoa

@objcMembers public class YTVimeoVideo: NSObject {
    public let title: String
    public let duration: TimeInterval
    public let stream: YTVimeoVideoStream
    
    internal init?(videoIdentifier: String, configuration: [String : Any], downloadConfiguration: [String : Any]?) throws {
        guard let videoInfo = configuration["video"] as? [String : Any] else { return nil }
        guard let stream = try? YTVimeoVideoStream(configuration: configuration, downloadConfiguration: downloadConfiguration) else { return nil }
        
        self.stream = stream
        self.title = videoInfo["title"] as? String ?? ""
        self.duration = videoInfo["duration"] as? TimeInterval ?? 0
    }
}
