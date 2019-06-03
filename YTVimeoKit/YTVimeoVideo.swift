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
    public var streamURLs: [UInt : URL]
    public enum YTVimeoVideoQuality: UInt {
        case low270 = 270
        case medium360 = 360
        case medium480 = 480
        case medium540 = 540
        case HD720 = 720
        case HD1080p = 1080
    }
    
    internal init?(videoIdentifier: String, configuration: [String : Any], downloadConfiguration: [String : Any]?) throws {
        guard let videoInfo = configuration["video"] as? [String : Any] else { return nil }
        guard let progressiveData = (configuration  as NSDictionary).value(forKeyPath: "request.files.progressive") as? [[String : Any]] else { return nil}
        
        self.title = videoInfo["title"] as? String ?? ""
        self.duration = videoInfo["duration"] as? TimeInterval ?? 0
        
        var streamURLs: [UInt : URL] = [:]
        
        for info in progressiveData {
            guard let height = info["height"] as? UInt else { continue }
            guard let urlString = info["url"] as? String else { continue }
            guard let url = URL(string: urlString) else { continue }
            
            streamURLs[height] = url
        }
        
        guard streamURLs.isEmpty == false else { return nil }
        self.streamURLs = streamURLs
    }
}
