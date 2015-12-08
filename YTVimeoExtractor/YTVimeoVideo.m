//
//  YTVimeoVideo.m
//  Sample
//
//  Created by Soneé Delano John on 11/28/15.
//  Copyright © 2015 Louis Larpin. All rights reserved.
//

#import "YTVimeoVideo.h"
#import "YTVimeoError.h"
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
    
    NSDictionary *videoInfo = [info valueForKey:@"video"];
    _metaData = videoInfo;
    NSDictionary *thumbnailsInfo = [videoInfo valueForKeyPath:@"thumbs"];
    
    _identifier = identifier;
    NSString *title = videoInfo[@"title"] ?: @"";
    
    _duration = [videoInfo[@"duration"] doubleValue];
    _title = title;

    
    NSArray *filesInfo = [info valueForKeyPath:@"request.files.progressive"];
   

    
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
    
    if (streamURLs.count == 0) {
        return nil;
    }else{
        _streamURLs = [streamURLs copy];
    }
    
    for (NSString *key in thumbnailsInfo) {
        
        NSInteger thumbnailquality = [key integerValue];
        NSString *thumbnailURL = thumbnailsInfo[key];
        thumbnailURLs [@(thumbnailquality)] = thumbnailURL;
    }
    
    _thumbnailURLs = [thumbnailURLs copy];
    
    return self;
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
