//
//  YTVimeoExtractor.h
//  YTVimeoExtractor
//
//  Created by Louis Larpin on 18/02/13.
//

#import <Foundation/Foundation.h>

#define kVimeoMobileURL @"http://vimeo.com/m/"
#define kUserAgent      @"Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3"

#define YTVimeoExtractorErrorDomain @"YTVimeoExtractorErrorDomain"
#define YTVimeoExtractorErrorCodeInvalidHTML 1
#define YTVimeoExtractorErrorCodeNoStreamURL 2
#define YTVimeoExtractorErrorCodeNotInitialized 3

typedef void (^YTSuccessBlock)(NSURL *videoURL);
typedef void (^YTErrorBlock)(NSError *error);

typedef enum {
    YTVimeoVideoQualityLow    = 0,
    YTVimeoVideoQualityMedium = 1,
    YTVimeoVideoQualityHigh   = 2,
} YTVimeoVideoQuality;

@protocol  YTVimeoExtractorDelegate;

@interface YTVimeoExtractor : NSObject <NSURLConnectionDelegate>

@property (nonatomic, readonly) BOOL running;
@property (nonatomic, readonly) YTVimeoVideoQuality quality;

@property (strong, nonatomic, readonly) NSURL *vimeoURL;
@property (strong, nonatomic, readonly) NSURL *streamURL;

@property (unsafe_unretained, nonatomic) id<YTVimeoExtractorDelegate> delegate;

+ (void)fetchVideoURLFromURL:(NSString *)videoURL
                     quality:(YTVimeoVideoQuality)quality
                     success:(YTSuccessBlock)success
                     failure:(YTErrorBlock)failure;
+ (void)fetchVideoURLFromID:(NSString *)videoID
                    quality:(YTVimeoVideoQuality)quality
                    success:(YTSuccessBlock)success
                    failure:(YTErrorBlock)failure;

- (id)initWithURL:(NSString *)videoURL quality:(YTVimeoVideoQuality)quality;
- (id)initWithID:(NSString *)videoID quality:(YTVimeoVideoQuality)quality;

- (void)start;

@end

@protocol YTVimeoExtractorDelegate <NSObject>

- (void)vimeoExtractor:(YTVimeoExtractor *)extractor didSuccessfullyExtractVimeoURL:(NSURL *)videoURL;
- (void)vimeoExtractor:(YTVimeoExtractor *)extractor failedExtractingVimeoURLWithError:(NSError *)error;

@end
