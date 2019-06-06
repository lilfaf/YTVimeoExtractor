//
//  YTVimeoVideo.swift
//  YTVimeoKit
//
//  Created by Soneé John on 6/3/19.
//  Copyright © 2019 Louis Larpin. All rights reserved.
//

import Foundation

@objcMembers public class YTVimeoVideo: NSObject {
    public let title: String
    public let duration: TimeInterval
    public let streams: [YTVimeoVideoStream]
    
    internal init?(videoIdentifier: String, configuration: [String : Any], downloadConfiguration: [String : Any]?) throws {
        guard let videoInfo = configuration["video"] as? [String : Any] else { return nil }
        guard let progressiveData = (configuration  as NSDictionary).value(forKeyPath: "request.files.progressive") as? [[String : Any]] else { return nil }
        
        self.title = videoInfo["title"] as? String ?? ""
        self.duration = videoInfo["duration"] as? TimeInterval ?? 0
        
        var streams: [YTVimeoVideoStream] = []
        
        for info in progressiveData {
            guard let height = info["height"] as? Int else { continue }
            guard let width = info["width"] as? Int else { continue }
            guard let urlString = info["url"] as? String else { continue }
            guard let url = URL(string: urlString) else { continue }
            streams.append(YTVimeoVideoStream(url: url, size: .init(width: width, height: height)))
        }
        
        //Sort the streams from biggest to smallest (first object being the largest size stream)
        streams = streams.sorted(by: { ($0.size.height * $0.size.width) > ($1.size.height * $1.size.width) })
        
        guard streams.isEmpty == false else { return nil }
        self.streams = streams
    }
}
