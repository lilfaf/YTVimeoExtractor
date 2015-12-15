//
//  YTVimeoVideo.m
//  Sample
//
//  Created by Soneé Delano John on 11/28/15.
//  Copyright © 2015 Louis Larpin. All rights reserved.
//

#import "YTVimeoVideo.h"
#import "YTVimeoError.h"

@interface YTVimeoVideo ()
@property (nonatomic, strong) NSDictionary *infoDict;

@end
NSString *const YTVimeoVideoErrorDomain = @"YTVimeoVideoErrorDomain";
@implementation YTVimeoVideo

#pragma mark -
- (instancetype) init
{
    @throw [NSException exceptionWithName:NSGenericException reason:@"Use the `initWithIdentifier:info` method instead." userInfo:nil];
}

- (instancetype)initWithIdentifier:(NSString *)identifier info:(NSDictionary *)info{
    
    NSParameterAssert(identifier);
    NSParameterAssert(info);
    
    if (!(self = [super init]))
        return nil; // LCOV_EXCL_LINE
    _infoDict = [info copy];
    _identifier = identifier;
    
    return self;
}
#pragma mark - 
- (void)extractVideoInfoWithCompletionHandler:(void (^)(NSError *error))completionHandler{

    if (!completionHandler)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"The `completionHandler` must not be nil." userInfo:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
    NSDictionary *videoInfo = [self.infoDict valueForKey:@"video"];
    
    NSDictionary *thumbnailsInfo = [videoInfo valueForKeyPath:@"thumbs"];
    if (thumbnailsInfo.count == 0 || thumbnailsInfo == nil) {
        //Private video
        //This could also be a deleted video. However, the `YTVimeoExtractorOperation`class will catch deleted videos. 
        NSError *privateError = [NSError errorWithDomain:YTVimeoVideoErrorDomain code:YTVimeoErrorRestrictedPlayback userInfo:@{NSLocalizedDescriptionKey:@"The operation was unable to finish sucessfully.", NSLocalizedFailureReasonErrorKey: @"The requested Vimeo video is private."}];
        completionHandler(privateError);
        return;
    }
    
    _metaData = videoInfo;

    NSString *title = videoInfo[@"title"] ?: @"";
    
    _duration = [videoInfo[@"duration"] doubleValue];
    _title = title;
    
    
    NSArray *filesInfo = [self.infoDict valueForKeyPath:@"request.files.progressive"];
    
    
    NSMutableDictionary *streamURLs = [NSMutableDictionary new];
    NSMutableDictionary *thumbnailURLs = [NSMutableDictionary new];
    
    
    for (NSDictionary *info in filesInfo) {
        
        NSInteger quality = [[info valueForKey:@"quality"]integerValue];
        NSString *urlString = info[@"url"];
        
        //Only if the file is playable on OS X or iOS natively
        if([urlString rangeOfString:@".mp4"].location != NSNotFound){
            
            streamURLs[@(quality)] = urlString;
            
        }
    }
    
    if (streamURLs.count == 0 || streamURLs == nil) {
        
        NSError *unsuitableError = [NSError errorWithDomain:YTVimeoVideoErrorDomain code:YTVimeoErrorNoSuitableStreamAvailable userInfo:@{NSLocalizedDescriptionKey:@"The operation was unable to finish sucessfully.", NSLocalizedFailureReasonErrorKey: @"The requested Vimeo video does not have a suitable stream. The file cannot natively play on iOS or OS X."}];
        
        completionHandler(unsuitableError);
        return;
    
    }else{
        
        _streamURLs = [streamURLs copy];
    }
    
    
    for (NSString *key in thumbnailsInfo) {
        
        NSInteger thumbnailquality = [key integerValue];
        NSString *thumbnailURL = thumbnailsInfo[key];
        thumbnailURLs [@(thumbnailquality)] = thumbnailURL;
    }
    
    _thumbnailURLs = [thumbnailURLs copy];
    
    completionHandler(nil);

    });
}


#pragma mark - NSObject
- (NSString *) description
{
    return [NSString stringWithFormat:@"[%@] %@", self.identifier, self.title];
}
#pragma mark - NSCopying

- (id) copyWithZone:(NSZone *)zone
{
    return self;
}

@end
