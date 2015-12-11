//
//  YTVimeoExtractor.h
//  YTVimeoExtractor
//
//  Created by Louis Larpin on 18/02/13.
//

#import <Foundation/Foundation.h>
#import "YTVimeoError.h"
#import "YTVimeoExtractorOperation.h"
#import "YTVimeoError.h"
#import "YTVimeoURLParser.h"
#import "YTVimeoVideo.h"
@interface YTVimeoExtractor : NSObject <NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

+(instancetype)sharedExtractor;

-(void)fetchVideoWithIdentifier:(NSString *)videoIdentifier withReferer:(NSString *)referer completionHandler:(void (^)(YTVimeoVideo * __nullable video, NSError * __nullable error))completionHandler;

-(void)fetchVideoWithVimeoURL:(NSString *)videoURL withReferer:(NSString *)referer completionHandler:(void (^)(YTVimeoVideo * __nullable video, NSError * __nullable error))completionHandler;



@end


