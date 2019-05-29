//
//  YTVimeoOperation.swift
//  YTVimeoKit
//
//  Created by Soneé John on 5/29/19.
//  Copyright © 2019 Louis Larpin. All rights reserved.
//

import Foundation

@objcMembers public class YTVimeoOperation: Operation {
    
    //MARK: - Operation
    
    override public var isExecuting: Bool { return state == .executing }
    override public var isFinished: Bool { return state == .finished }
    override public var isAsynchronous: Bool { return true }
    
    fileprivate var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    fileprivate enum State: String {
        case ready = "Ready"
        case executing = "Executing"
        case finished = "Finished"
        fileprivate var keyPath: String { return "is" + self.rawValue }
    }
    
    enum RequestType {
        case WatchPageRequest
    }
    
    // MARK: -
    public let videoIdentifier: String
    public let referer: String?
    
    fileprivate let session: URLSession
    fileprivate var dataTask: URLSessionDataTask?
    
    fileprivate var requestType: RequestType?
    //MARK: - Init
    
    public init(videoIdentifier: String, referer: String?) {
        self.videoIdentifier = videoIdentifier
        self.referer = referer
        
        self.session = URLSession(configuration: URLSessionConfiguration.ephemeral)
    }
    
    //MARK: - Main
    
    override public func start() {
        guard !isCancelled else { return }
        
        startReqest()
    }
    
    fileprivate func startReqest() {
        requestType = .WatchPageRequest
        
        var request = URLRequest(url: URL(string: "https://vimeo.com/\(videoIdentifier)")!)
        request.addValue("\(referer ?? "")", forHTTPHeaderField: "Referer")
        
        dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            self.handleData(data, response: response, error: error)
        })
        
        dataTask?.resume()
    }
    
    fileprivate func handleData(_ data: Data?, response: URLResponse?, error: Error?) {
        //TODO: Error reporting
        guard data != nil else { return }
        guard error == nil else { return }
        
        switch requestType {
        case .WatchPageRequest?:
            let html = String(decoding: data!, as: UTF8.self)
            handleWatchPageRequest(HTML: html)
        default:
            break
        }
    }
    
    fileprivate func handleWatchPageRequest(HTML: String) {
        guard let regex = try? NSRegularExpression(pattern: "vimeo\\.config\\s*=\\s*(?:(\\{.+?\\})|_extend\\([^,]+,\\s+(\\{.+?\\})\\));", options: []) else { return }
        let matches = regex.matches(in: HTML, options: [], range: NSMakeRange(0, HTML.count))
        
        var vimeoConfiguration: [String : Any]?
        
        matches.forEach { (result) in
            let groups = result.groups(string: HTML)
            for string in groups {
                guard let data = string.data(using: .utf8) else { continue }
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else { continue }
                vimeoConfiguration = json
                break
            }
        }
        
        guard vimeoConfiguration?["state"] as? String != "failed" else { return }
        var configurationURL: URL?
        
        let configURLRegex = try? NSRegularExpression(pattern: " data-config-url=\"(.+?)\"", options: [])
        guard configURLRegex?.matches(in: HTML, options: [], range: NSMakeRange(0, HTML.count)).isEmpty ?? false else {
            let regex = try? NSRegularExpression(pattern: "vimeo\\.clip_page_config\\s*=\\s*(\\{.+?\\});", options: [])
            let matches = regex?.matches(in: HTML, options: [], range: NSMakeRange(0, HTML.count))
            
            var vimeoClipPageConfiguration: [String : Any]?
            
            matches?.forEach { (result) in
                let groups = result.groups(string: HTML)
                for string in groups {
                    guard let data = string.data(using: .utf8) else { continue }
                    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else { continue }
                    vimeoClipPageConfiguration = json
                    break
                }
            }
            guard let configurationURLString = (vimeoClipPageConfiguration as NSDictionary?)?.value(forKeyPath: "player.config_url") as? String else { return }
            configurationURL = URL(string: configurationURLString)
            return
        }
        
        //TODO: Check matches from configURLRegex for alternative way to get configurationURL
    }
}
