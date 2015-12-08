//
//  YTVimeoVideo.h
//  Sample
//
//  Created by Soneé Delano John on 11/28/15.
//  Copyright © 2015 Louis Larpin. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  The various thumbnails of Vimeo videos. These values are used as keys in the `<[YTVimeoVideo thumbnailURLs]>` property.
 */
typedef NS_ENUM(NSUInteger, YTVimeoVideoThumbnailQuality) {
    /**
     *  A thumbnail URL for an image of small size with a width of 640 pixels.
     */
    YTVimeoVideoThumbnailQualitySmall  = 640,
    /**
     *  A thumbnail URL for an image of medium size with a width of 960 pixels.
     */
    YTVimeoVideoThumbnailQualityMedium = 960,
    /**
     *  A thumbnail URL for an image of high definition quality with a width of 1280 pixels.
     */
     YTVimeoVideoThumbnailQualityHD     = 1280,
};
@interface YTVimeoVideo : NSObject

/**
 *  Initializes a `YTVimeoVideo` video object with the specified  identifier and info.
 *
 *  @param identifier A Vimeo video identifier. This parameter should not be `nil`
 *  @param info The dictionary that the class will use to parse out the data. This parameter should not be `nil`
 *
 *  @return A newly initialized `YTVimeoVideo` object.
 */
- (nullable instancetype) initWithIdentifier:(NSString *_Nonnull)identifier info:(NSDictionary *_Nonnull)info;

- (void)extractVideoInfoWithCompletionHandler:(void (^_Nonnull)(NSError * __nullable error))completionHandler;



/**
 *  The Vimeo video identifier.
 */
@property (nonatomic, readonly) NSString *__nullable identifier;
/**
 *  The title of the video.
 */
@property (nonatomic, readonly) NSString *__nullable title;
/**
 *  The duration of the video in seconds.
 */
@property (nonatomic, readonly) NSTimeInterval duration;

/**
 *  A `NSDictionary` object that contains the various stream URLs.
 */
@property (nonatomic, readonly) NSDictionary *__nullable streamURLs;
/**
 *  A `NSDictionary` object that contains the various thumbnail URLs.
 *  @see YTVimeoVideoThumbnailQuality
 */
@property (nonatomic, readonly) NSDictionary *__nullable thumbnailURLs;
/**
 *  A `NSDictionary` object that contains all the metadata about the video.
 */
@property (nonatomic, readonly) NSDictionary *__nullable metaData;

@end
