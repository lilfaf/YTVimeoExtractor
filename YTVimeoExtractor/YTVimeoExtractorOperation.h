//
//  YTVimeoExtractorOperation.h
//  Sample
//
//  Created by Soneé Delano John on 11/28/15.
//  Copyright © 2015 Louis Larpin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTVimeoVideo.h"

/**
 `YTVimeoExtractorOperation` is a subclass of NSOperation and is used to fetch and parse out information about Vimeo videos. This a low level class. Generally, you should use the higher level `YTVimeoExtractor` class.
 */
@interface YTVimeoExtractorOperation : NSOperation
/**
 *  ------------------
 *  @name Initializing
 *  ------------------
 */

/**
 *  Creates a new extractor operation with the specified Vimeo video identifier and referer.
 *
 *  @param videoIdentifier A Vimeo video identifier.
 *  @param videoReferer The referer, if the Vimeo video has domain-level restrictions. If this value is `nil` then a default one will be used.
 *
 *  @return An initialized `YTVimeoExtractorOperation` object.
 */
-(instancetype)initWithVideoIdentifier:(NSString *)videoIdentifier referer:(NSString *)videoReferer;
/**
 *  Creates a new extractor operation with the specified Vimeo video URL and referer.
 *
 *  @param videoURL     A Vimeo video URL.
 *  @param videoReferer  The referer, if the Vimeo video has domain-level restrictions. If this value is `nil` then a default one will be used.
 *
 *  @return An initialized `YTVimeoExtractorOperation` object.
 */

- (instancetype)initWithURL:(NSString *)videoURL referer:(NSString *)videoReferer;

/**
 *  ------------------------------------
 *  @name Accessing Operation Properties
 *  ------------------------------------
 */

/**
 *  Returns a `YTVimeoVideo` object if the operation finished sucessfully. Otherwise, will be `nil`.
 */
@property (nonatomic, readonly) YTVimeoVideo *operationVideo;
/**
 *  The data that the operation parsed out. This value may be nil.
 */
@property (nonatomic, readonly) NSDictionary *jsonDict;
/**
 *  Any errors that may have occurred during the operation. Will be `nil` if the operation finished unsuccessfully. Otherwise, will return an error of the `YTVimeoVideoErrorDomain` domain.
 */
@property (nonatomic, readonly) NSError *error;
@end
