//
//  YTVimeoExtractor.h
//  YTVimeoExtractor
//
//  Created by Louis Larpin on 18/02/13.
//

#import <Foundation/Foundation.h>

extern NSString *const YTVimeoPlayerConfigURL;
extern NSString *const YTVimeoExtractorErrorDomain;

enum {
    YTVimeoExtractorErrorCodeNotInitialized,
    YTVimeoExtractorErrorInvalidIdentifier,
    YTVimeoExtractorErrorUnsupportedCodec,
    YTVimeoExtractorErrorUnavailableQuality
};

typedef enum YTVimeoVideoQuality : NSUInteger {
    YTVimeoVideoQualityLow,
    YTVimeoVideoQualityMedium,
    YTVimeoVideoQualityHigh
}YTVimeoVideoQuality;

typedef void (^completionHandler) (NSURL *videoURL, NSError *error, YTVimeoVideoQuality quality);

@protocol  YTVimeoExtractorDelegate;

@interface YTVimeoExtractor : NSObject <NSURLConnectionDelegate>

@property (nonatomic, readonly) BOOL running;
@property (nonatomic, readonly) YTVimeoVideoQuality quality;
@property (strong, nonatomic, readonly) NSURL *vimeoURL;

@property (unsafe_unretained, nonatomic) id<YTVimeoExtractorDelegate> delegate;

+ (void)fetchVideoURLFromURL:(NSString *)videoURL quality:(YTVimeoVideoQuality)quality completionHandler:(completionHandler)handler;
+ (void)fetchVideoURLFromID:(NSString *)videoURL quality:(YTVimeoVideoQuality)quality completionHandler:(completionHandler)handler;

- (id)initWithURL:(NSString *)videoURL quality:(YTVimeoVideoQuality)quality;
- (id)initWithID:(NSString *)videoID quality:(YTVimeoVideoQuality)quality;

- (void)start;

@end

@protocol YTVimeoExtractorDelegate <NSObject>

- (void)vimeoExtractor:(YTVimeoExtractor *)extractor didSuccessfullyExtractVimeoURL:(NSURL *)videoURL withQuality:(YTVimeoVideoQuality)quality;
- (void)vimeoExtractor:(YTVimeoExtractor *)extractor failedExtractingVimeoURLWithError:(NSError *)error;

@end
