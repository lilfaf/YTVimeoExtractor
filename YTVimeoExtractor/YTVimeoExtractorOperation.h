//
//  YTVimeoExtractorOperation.h
//  Sample
//
//  Created by Soneé Delano John on 11/28/15.
//  Copyright © 2015 Louis Larpin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTVimeoVideo.h"
@interface YTVimeoExtractorOperation : NSOperation

-(instancetype)initWithVideoIdentifier:(NSString *)videoIdentifier referer:(NSString *)videoReferer;
@property (nonatomic, readonly) YTVimeoVideo *operationVideo;
@property (nonatomic, readonly) NSDictionary *jsonDict;
@property (nonatomic, readonly) NSError *error;
@end
