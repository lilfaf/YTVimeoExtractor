//
//  YTVimeoVideo.swift
//  YTVimeoKit
//
//  Created by Soneé John on 6/3/19.
//  Copyright © 2019 Louis Larpin. All rights reserved.
//

import Foundation

@objcMembers public class YTVimeoVideo: NSObject {
    
    @objc public enum YTVimeoVideoStreamQuality: Int {
        case low270 = 270
        case medium360 = 360
        case medium480 = 480
        case medium540 = 540
        case HD720 = 720
        case HD1080p = 1080
    }
    
    public let title: String
    public let duration: TimeInterval
    public let streams: [YTVimeoVideoStream]
    public var sourceStream: YTVimeoVideoStream?
    
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
        
        if let sourceInfo = downloadConfiguration?["source_file"] as? [String : Any] {
            let height = sourceInfo["height"] as? Int
            let width = sourceInfo["width"] as? Int
            let urlString = sourceInfo["download_url"] as? String
            
            if (height != nil) && (width != nil) && urlString != nil {
                let url = URL(string: urlString!)
                let stream = YTVimeoVideoStream(url: url!, size: .init(width: width!, height: height!), isSourceStream: true)
                self.sourceStream = stream
                streams.append(stream)
            }
        }
        //Sort the streams from biggest to smallest (first object being the largest size stream)
        streams = streams.sorted(by: { ($0.size.height * $0.size.width) > ($1.size.height * $1.size.width) })
        //The sourceStream should be placed first
        streams = streams.sorted(by: { $0.isSourceStream || $1.isSourceStream == true })
        
        guard streams.isEmpty == false else { return nil }
        self.streams = streams
    }
    
    public func streamQuality(desiredQuality: YTVimeoVideoStreamQuality) -> YTVimeoVideoStream? {
        //Sort from smallest to largest
        let sorted = self.streams.sorted(by: { ($0.size.height * $0.size.width) < ($1.size.height * $1.size.width) })
        
        let overStream = sorted.first(where: { Int($0.size.height) >= desiredQuality.rawValue })
        let underStream = sorted.last(where: { Int($0.size.height) <= desiredQuality.rawValue })
        
        guard overStream != nil else {
            return underStream
        }
        
        guard underStream != nil else {
            return overStream
        }
        
        let diffOver = Int(overStream!.size.height) - desiredQuality.rawValue
        let diffUnder = desiredQuality.rawValue - Int(underStream!.size.height)
        
        return (diffOver < diffUnder) ? overStream : underStream
    }
}
