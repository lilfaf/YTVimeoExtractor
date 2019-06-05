//
//  YTVimeoVideoStream.swift
//  YTVimeoKit
//
//  Created by Soneé John on 6/5/19.
//  Copyright © 2019 Louis Larpin. All rights reserved.
//

import Cocoa

@objcMembers public class YTVimeoVideoStream: NSObject {
    
    public var sourceURL: URL? {
        get {
            guard let sourceURLString = (downloadConfiguration as NSDictionary?)?.value(forKeyPath: "source_file.download_url") as? String else { return nil }
            return URL(string: sourceURLString)
        }
    }
    
    public var streamURLs: [YTVimeoVideoStreamQuality : URL]
    public enum YTVimeoVideoStreamQuality: UInt {
        case low270 = 270
        case medium360 = 360
        case medium480 = 480
        case medium540 = 540
        case HD720 = 720
        case HD1080p = 1080
    }
    
    fileprivate let downloadConfiguration: [String : Any]?

    internal init?(configuration: [String : Any], downloadConfiguration: [String : Any]?) throws {
        guard let progressiveData = (configuration  as NSDictionary).value(forKeyPath: "request.files.progressive") as? [[String : Any]] else { return nil }
        
        self.downloadConfiguration = downloadConfiguration
        var streamURLs: [YTVimeoVideoStreamQuality : URL] = [:]
        
        for info in progressiveData {
            guard let height = info["height"] as? UInt else { continue }
            guard let urlString = info["url"] as? String else { continue }
            guard let url = URL(string: urlString) else { continue }
            guard let streamQuality = YTVimeoVideoStreamQuality(rawValue: height) else { continue }
            
            streamURLs[streamQuality] = url
        }
        
        guard streamURLs.isEmpty == false else { return nil }
        self.streamURLs = streamURLs
    }
}
