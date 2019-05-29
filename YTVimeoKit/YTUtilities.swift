//
//  YTUtilities.swift
//  YTVimeoKit
//
//  Created by Soneé John on 5/29/19.
//  Copyright © 2019 Louis Larpin. All rights reserved.
//

import Foundation

extension NSTextCheckingResult {
    func groups(string: String) -> [String] {
        var groups = [String]()
        for i in  0 ..< self.numberOfRanges {
            guard let range = Range(self.range(at: i), in: string) else { continue }
            let group = String(string[range])
            groups.append(group)
        }
        return groups
    }
}
