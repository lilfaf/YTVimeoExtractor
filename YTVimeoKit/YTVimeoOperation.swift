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
        case ConfigurationResult
        case DownloadConfigurationResult
    }
    
    // MARK: -
    public let videoIdentifier: String
    public let referer: String?
    
    public var video: YTVimeoVideo?
    
    fileprivate let session: URLSession
    fileprivate var dataTask: URLSessionDataTask?
    
    fileprivate var requestType: RequestType?
    fileprivate var webpage: YTVimeoVideoWebpage?
    
    fileprivate var configuration: [String : Any]?
    fileprivate var downloadConfiguration: [String : Any]?
    
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
        var request = URLRequest(url: URL(string: "https://vimeo.com/\(videoIdentifier)")!)
        request.addValue("\(referer ?? "")", forHTTPHeaderField: "Referer")
        
        self.request(request: request, requestType: .WatchPageRequest)
    }
    
    fileprivate func request(request: URLRequest, requestType: RequestType) {
        self.requestType = requestType
       
        dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            self.handleData(data, response: response, error: error)
        })
        
        dataTask?.resume()
    }
    
    fileprivate func handleData(_ data: Data?, response: URLResponse?, error: Error?) {
        //TODO: Error reporting
        guard data != nil else { return }
        guard error == nil else { return }
        
        if let httpResponse = response as? HTTPURLResponse {
            guard httpResponse.statusCode == 200 else {
                if self.requestType == .DownloadConfigurationResult {
                    //Sometimes the download configuration will return 403
                    //This is okay we simply work with the json that we have
                    guard self.configuration != nil else { return }
                    finishWithVideo(configuration: self.configuration!, downloadConfiguration: nil)
                }
                return
            }
        }
        
        switch requestType {
        case .WatchPageRequest?:
            let html = String(decoding: data!, as: UTF8.self)
            handleWatchPageRequest(HTML: html)
        case .DownloadConfigurationResult?:
            guard let configuration = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any] else { return }
            handleDownloadConfigurationRequest(configuration: configuration)
        case .ConfigurationResult?:
            guard let configuration = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any] else { return }
            handleConfigurationResult(configuration: configuration)
        default:
            break
        }
    }
    
    fileprivate func handleWatchPageRequest(HTML: String) {
        webpage = YTVimeoVideoWebpage(html: HTML)
        guard webpage?.vimeoConfiguration?["state"] as? String != "failed" else { return }
        guard webpage != nil else { return }
        guard webpage?.configurationURL != nil else { return }
        
        startConfigurationRequest(url: webpage!.configurationURL!)
    }
    
    fileprivate func startConfigurationRequest(url: URL) {
        let request = URLRequest(url: url)
        self.request(request: request, requestType: .ConfigurationResult)
    }
    
    fileprivate func handleConfigurationResult(configuration: [String : Any]) {
        self.configuration = configuration
        startDownloadConfigurationRequest()
    }
    
    fileprivate func startDownloadConfigurationRequest() {
        guard var urlComponents = URLComponents(string: "https://vimeo.com/\(videoIdentifier)") else { return }
        if #available(OSX 10.10, *) {
            urlComponents.queryItems = [URLQueryItem(name: "action", value: "load_download_config")]
        } else {
            // Fallback on earlier versions
        }
        guard urlComponents.url != nil else { return }
        
        var request = URLRequest(url: urlComponents.url!)
        request.addValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        
        self.request(request: request, requestType: .DownloadConfigurationResult)
    }
    
    fileprivate func handleDownloadConfigurationRequest(configuration: [String : Any]) {
        self.downloadConfiguration = configuration
        
        guard self.configuration != nil else { return }
        finishWithVideo(configuration: self.configuration!, downloadConfiguration: self.downloadConfiguration)
    }
    
    fileprivate func finishWithVideo(configuration: [String : Any], downloadConfiguration: [String : Any]?) {
        guard let video = try? YTVimeoVideo(videoIdentifier: videoIdentifier, configuration: configuration, downloadConfiguration: downloadConfiguration) else { return }
        
        self.video = video
        state = .finished
    }
}
