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
/**
 *  The various stream or download URLs of Vimeo videos. These values are used as keys in the `<[YTVimeoVideo streamURLs]>` property.
 */
typedef NS_ENUM(NSUInteger, YTVimeoVideoQuality) {
    /**
     *  A stream URL for a video of low quality with a height of 270 pixels.
     */
    YTVimeoVideoQualityLow270    = 270,
    /**
     *  A stream URL for a video of medium quality with a height of 360 pixels.
     */
    YTVimeoVideoQualityMedium360 = 360,
    /**
     *  A stream URL for a video of medium quality with a height of 480 pixels.
     */
    YTVimeoVideoQualityMedium480 = 480,
    /**
     *  A stream URL for a video of HD quality with a height of 720 pixels.
     */
    YTVimeoVideoQualityHD720     = 720,
    /**
     *  A stream URL for a video of HD quality with a height of 1080 pixels.
     */
    YTVimeoVideoQualityHD1080    = 1080,
};

/// YTVimeoVideo represents a Vimeo video. Use this class to access information about a particular video. Generally, you should not initialize this class, instead use the `<-[YTVimeoExtractor fetchVideoWithVimeoURL:withReferer:completionHandler:]>` or `<-[YTVimeoExtractor fetchVideoWithIdentifier:withReferer:completionHandler:]>` methods to get a `YTVimeoVideo` object.
@interface YTVimeoVideo : NSObject

/**
 *  ------------------
 *  @name Initializing
 *  ------------------
 */

/**
 *  Initializes a `YTVimeoVideo` video object with the specified identifier and info.
 *
 *  @param identifier A Vimeo video identifier. This parameter should not be `nil`
 *  @param info The dictionary that the class will use to parse out the data. This parameter should not be `nil`
 *
 *  @return A newly initialized `YTVimeoVideo` object.
 */
- (nullable instancetype) initWithIdentifier:(NSString *_Nonnull)identifier info:(NSDictionary *_Nonnull)info;

/**
 *  ----------------------------
 *  @name Extracting Information
 *  ----------------------------
 */

/**
 *  Starts extracting information about the Vimeo video.
 *
 *  @param completionHandler A block to execute when the extraction process is finished. The completion handler is executed on the main thread. If the completion handler is nil, this method throws an exception.
 */
- (void)extractVideoInfoWithCompletionHandler:(void (^_Nonnull)(NSError * __nullable error))completionHandler;

/**
 *  ----------------------------
 *  @name Accessing Information
 *  ----------------------------
 */
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
 * @see YTVimeoVideoQuality
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
