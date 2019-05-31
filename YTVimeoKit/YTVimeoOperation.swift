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
    fileprivate var webpage: YTVimeoVideoWebpage?
    
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
        webpage = YTVimeoVideoWebpage(html: HTML)
        guard webpage?.vimeoConfiguration?["state"] as? String != "failed" else { return }
        print(webpage?.configurationURL)
        
    }
}
