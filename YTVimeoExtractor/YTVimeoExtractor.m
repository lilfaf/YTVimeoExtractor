//
//  YTVimeoExtractor.m
//  YTVimeoExtractor
//
//  Created by Louis Larpin on 18/02/13.
//

#import "YTVimeoExtractor.h"

NSString *const YTVimeoPlayerConfigURL = @"https://player.vimeo.com/video/%@/config";
NSString *const YTVimeoExtractorErrorDomain = @"YTVimeoExtractorErrorDomain";

@interface YTVimeoExtractor ()

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSMutableData *buffer;
@property (copy, nonatomic) completionHandler completionHandler;
@property (copy, nonatomic) metadataCompletionHandler metadataCompletionHandler;

- (void)extractorFailedWithMessage:(NSString*)message errorCode:(int)code;

@end

@implementation YTVimeoExtractor

+ (void)fetchVideoURLFromURL:(NSString *)videoURL quality:(YTVimeoVideoQuality)quality referer:(NSString *)referer completionHandler:(completionHandler)handler
{
    YTVimeoExtractor *extractor = [[YTVimeoExtractor alloc] initWithURL:videoURL quality:quality referer:referer];
    extractor.completionHandler = handler;
    [extractor start];
}

+ (void)fetchVideoURLFromID:(NSString *)videoID quality:(YTVimeoVideoQuality)quality referer:(NSString *)referer completionHandler:(completionHandler)handler
{
    YTVimeoExtractor *extractor = [[YTVimeoExtractor alloc] initWithID:videoID quality:quality referer:referer];
    extractor.completionHandler = handler;
    [extractor start];
}

+ (void)fetchVideoURLFromURL:(NSString *)videoURL quality:(YTVimeoVideoQuality)quality completionHandler:(completionHandler)handler
{
    return [YTVimeoExtractor fetchVideoURLFromURL:videoURL quality:quality referer:nil completionHandler:handler];
}

+ (void)fetchVideoURLFromID:(NSString *)videoID quality:(YTVimeoVideoQuality)quality completionHandler:(completionHandler)handler
{
    return [YTVimeoExtractor fetchVideoURLFromID:videoID quality:quality referer:nil completionHandler:handler];
}

+ (void)fetchVideoMetadataFromURL:(NSString *)videoURL quality:(YTVimeoVideoQuality)quality referer:(NSString *)referer completionHandler:(metadataCompletionHandler)handler
{
    YTVimeoExtractor *extractor = [[YTVimeoExtractor alloc] initWithURL:videoURL quality:quality referer:referer];
    extractor.metadataCompletionHandler = handler;
    [extractor start];
}

+ (void)fetchVideoMetadataFromID:(NSString *)videoID quality:(YTVimeoVideoQuality)quality referer:(NSString *)referer completionHandler:(metadataCompletionHandler)handler
{
    YTVimeoExtractor *extractor = [[YTVimeoExtractor alloc] initWithID:videoID quality:quality referer:referer];
    extractor.metadataCompletionHandler = handler;
    [extractor start];
}

+ (void)fetchVideoMetadataFromURL:(NSString *)videoURL quality:(YTVimeoVideoQuality)quality completionHandler:(metadataCompletionHandler)handler
{
    return [YTVimeoExtractor fetchVideoMetadataFromURL:videoURL quality:quality referer:nil completionHandler:handler];
}

+ (void)fetchVideoMetadataFromID:(NSString *)videoID quality:(YTVimeoVideoQuality)quality completionHandler:(metadataCompletionHandler)handler
{
    return [YTVimeoExtractor fetchVideoMetadataFromID:videoID quality:quality referer:nil completionHandler:handler];
}

#pragma mark - Constructors

- (id)initWithID:(NSString *)videoID quality:(YTVimeoVideoQuality)quality referer:(NSString *)referer
{
    self = [super init];
    if (self) {
        _vimeoURL = [NSURL URLWithString:[NSString stringWithFormat:YTVimeoPlayerConfigURL, videoID]];
        _quality = quality;
        _referer = referer;
        _running = NO;
    }
    return self;
}

- (id)initWithURL:(NSString *)videoURL quality:(YTVimeoVideoQuality)quality referer:(NSString *)referer
{
    NSString *videoID = [NSURL URLWithString:videoURL].lastPathComponent;
    return [self initWithID:videoID quality:quality referer:referer];
}

- (id)initWithID:(NSString *)videoID quality:(YTVimeoVideoQuality)quality
{
    return [self initWithID:videoID quality:quality referer:nil];
}

- (id)initWithURL:(NSString *)videoURL quality:(YTVimeoVideoQuality)quality {
    return [self initWithURL:videoURL quality:quality referer:nil];
}

- (void)dealloc
{
    [self.session invalidateAndCancel];
    self.session = nil;
    self.buffer = nil;
    self.delegate = nil;
}

#pragma mark - Public

- (void)start
{
    if (!(self.delegate || self.completionHandler || self.metadataCompletionHandler) || !self.vimeoURL) {
        [self extractorFailedWithMessage:@"Delegate, block or URL not specified" errorCode:YTVimeoExtractorErrorCodeNotInitialized];
        return;
    }
    if (self.running) {
        [self extractorFailedWithMessage:@"Already in progress" errorCode:YTVimeoExtractorErrorCodeNotInitialized];
        return;
    }

    // build request headers
    NSMutableDictionary *sessionHeaders = [NSMutableDictionary dictionaryWithDictionary:@{@"Content-Type" : @"application/json"}];
    if (self.referer) {
        [sessionHeaders setValue:self.referer forKey:@"Referer"];
    }

    // configure the session
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    sessionConfig.HTTPAdditionalHeaders = sessionHeaders;

    // initialise the session
    self.session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];

    // start the request
    [[self.session dataTaskWithURL:self.vimeoURL] resume];

    _running = YES;
}

# pragma mark - Private

- (void)extractorFailedWithMessage:(NSString*)message errorCode:(int)code {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:YTVimeoExtractorErrorDomain code:code userInfo:userInfo];

    if (self.completionHandler) {
        self.completionHandler(nil, error, self.quality);
    }
    else if (self.metadataCompletionHandler) {
        self.metadataCompletionHandler(nil, nil, error, self.quality);
    }
    else if ([self.delegate respondsToSelector:@selector(vimeoExtractor:failedExtractingVimeoURLWithError:)]) {
        [self.delegate vimeoExtractor:self failedExtractingVimeoURLWithError:error];
    }
    _running = NO;
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if (httpResponse.statusCode != 200) {
        [self extractorFailedWithMessage:@"Invalid video indentifier" errorCode:YTVimeoExtractorErrorInvalidIdentifier];
        // cancel the session
        completionHandler(NSURLSessionResponseCancel);
    }

    // initialise data buffer
    NSUInteger capacity = 0;
    if (response.expectedContentLength != NSURLResponseUnknownLength) {
        capacity = (uint)response.expectedContentLength;
    }
    self.buffer = [[NSMutableData alloc] initWithCapacity:capacity];

    // continue the task normally
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.buffer appendData:data];
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
	NSError *jsonError;
	NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:self.buffer options:NSJSONReadingAllowFragments error:&jsonError];
	
	if (jsonError) {
		[self extractorFailedWithMessage:@"Invalid video indentifier" errorCode:YTVimeoExtractorErrorInvalidIdentifier];
		return;
	}
	
	NSArray *videoArray = [jsonData valueForKeyPath:@"request.files.progressive"];
	if (!videoArray) {
		[self extractorFailedWithMessage:@"Unsupported video codec" errorCode:YTVimeoExtractorErrorUnsupportedCodec];
		return;
	}
	
	NSDictionary *videoInfos;
	if (videoArray.count > 0) {
		if (self.quality == YTVimeoVideoQualityBestAvailable) {
			videoInfos = [videoArray lastObject];
		}
		else {
			switch (self.quality) {
				case YTVimeoVideoQualityLow:
					if (videoArray.count > 0) {
						videoInfos = [videoArray objectAtIndex:0];
					}
					break;
				case YTVimeoVideoQualityMedium:
					if (videoArray.count > 1) {
						videoInfos = [videoArray objectAtIndex:1];
					}
					break;
				default:
					if (videoArray.count > 2) {
						videoInfos = [videoArray objectAtIndex:2];
					}
					break;
			}
		}
	}
	
	if (videoInfos) {
		NSURL *fileURL = [NSURL URLWithString:[videoInfos objectForKey:@"url"]];
		if (self.completionHandler) {
			self.completionHandler(fileURL, nil, self.quality);
		}
		else if ([self.delegate respondsToSelector:@selector(vimeoExtractor:didSuccessfullyExtractVimeoURL:withQuality:)]) {
			[self.delegate vimeoExtractor:self didSuccessfullyExtractVimeoURL:fileURL withQuality:self.quality];
		}
	}
	else {
		[self extractorFailedWithMessage:@"Unavailable video quality" errorCode:YTVimeoExtractorErrorUnavailableQuality];
	}
	
	_running = NO;
}
@end
