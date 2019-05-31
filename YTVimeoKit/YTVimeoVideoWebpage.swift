//
//  YTVimeoVideoWebpage.swift
//  YTVimeoKit
//
//  Created by Soneé John on 5/30/19.
//  Copyright © 2019 Louis Larpin. All rights reserved.
//

import Foundation

class YTVimeoVideoWebpage {
    
    //MARK: -
    
    let html: String
    var configurationURL: URL? {
        get {
            let configURLRegex = try? NSRegularExpression(pattern: " data-config-url=\"(.+?)\"", options: [])
            let possibleURLResults = configURLRegex?.matches(in: html, options: [], range: NSMakeRange(0, html.count))
            
            guard possibleURLResults?.isEmpty ?? false else {
                let regex = try? NSRegularExpression(pattern: "vimeo\\.clip_page_config\\s*=\\s*(\\{.+?\\});", options: [])
                let matches = regex?.matches(in: html, options: [], range: NSMakeRange(0, html.count))
                
                var vimeoClipPageConfiguration: [String : Any]?
                
                matches?.forEach { (result) in
                    let groups = result.groups(string: html)
                    for string in groups {
                        guard let data = string.data(using: .utf8) else { continue }
                        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else { continue }
                        vimeoClipPageConfiguration = json
                        break
                    }
                }
                
                guard let configurationURLString = (vimeoClipPageConfiguration as NSDictionary?)?.value(forKeyPath: "player.config_url") as? String else { return nil }
                return URL(string: configurationURLString)
            }
            
            guard possibleURLResults != nil else { return nil }
            return URL(string: possibleURLResults![0].groups(string: html)[0])
        }
    }
    
    var vimeoConfiguration: [String : Any]? {
        get {
            guard let regex = try? NSRegularExpression(pattern: "vimeo\\.config\\s*=\\s*(?:(\\{.+?\\})|_extend\\([^,]+,\\s+(\\{.+?\\})\\));", options: []) else { return nil }
            let matches = regex.matches(in: html, options: [], range: NSMakeRange(0, html.count))
            
            var vimeoConfiguration: [String : Any]?
            
            matches.forEach { (result) in
                let groups = result.groups(string: html)
                for string in groups {
                    guard let data = string.data(using: .utf8) else { continue }
                    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else { continue }
                    vimeoConfiguration = json
                    break
                }
            }
            
            return vimeoConfiguration
        }
    }
    
    //MARK: - Init
    
    init(html: String) {
        self.html = html
    }
}
