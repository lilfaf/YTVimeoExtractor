//
//  YTVimeoExtractor.m
//  YTVimeoExtractor
//
//  Created by Louis Larpin on 18/02/13.
//

#import "YTVimeoExtractor.h"

@interface YTVimeoExtractor ()
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *buffer;
@property (strong, nonatomic) NSString *playerURL;
@property (copy, nonatomic) YTSuccessBlock success;
@property (copy, nonatomic) YTErrorBlock failure;

- (void)setupRequest:(NSMutableURLRequest **)request;
- (void)extractorFailedWithMessage:(NSString*)message errorCode:(int)code;
- (NSString *)playerURLFromHTML:(NSString *)html;
 
@end

@implementation YTVimeoExtractor
+ (void)fetchVideoURLFromURL:(NSString *)videoURL
                     quality:(YTVimeoVideoQuality)quality
                     success:(YTSuccessBlock)success
                     failure:(YTErrorBlock)failure
{
    YTVimeoExtractor *extractor = [[YTVimeoExtractor alloc] initWithURL:videoURL quality:quality];
    extractor.success = success;
    extractor.failure = failure;
    
    [extractor start];
}

+ (void)fetchVideoURLFromID:(NSString *)videoID
                    quality:(YTVimeoVideoQuality)quality
                    success:(YTSuccessBlock)success
                    failure:(YTErrorBlock)failure
{
    YTVimeoExtractor *extractor = [[YTVimeoExtractor alloc] initWithID:videoID quality:quality];
    extractor.success = success;
    extractor.failure = failure;
    
    [extractor start];
}

#pragma mark - Constructors

- (id)initWithID:(NSString *)videoID quality:(YTVimeoVideoQuality)quality {
    self = [super init];
    if (self) {
        _vimeoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kVimeoMobileURL, videoID]];
        _quality = quality;
        _running = NO;
    }
    return self;
}

- (id)initWithURL:(NSString *)videoURL quality:(YTVimeoVideoQuality)quality {
    NSString *videoID = [[videoURL componentsSeparatedByString:@"/"] lastObject];
    return [self initWithID:videoID quality:quality];
}

- (void)dealloc {
    [self.connection cancel];
    self.connection = nil;
    self.buffer = nil;
    self.delegate = nil;
}

#pragma mark - Public

- (void)start {
    if (!(self.delegate || self.success) || !self.vimeoURL) {
        [self extractorFailedWithMessage:@"Delegate or URL not specified" errorCode:YTVimeoExtractorErrorCodeNotInitialized];
        return;
    }
    if (self.running) {
        [self extractorFailedWithMessage:@"Already in progress" errorCode:YTVimeoExtractorErrorCodeNotInitialized];
        return;
    }
     
     _running = YES;
     
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.vimeoURL];
    [self setupRequest:&request];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

# pragma mark - Private

- (void)setupRequest:(NSMutableURLRequest **)request {
    [*request setValue:kUserAgent forHTTPHeaderField:@"User-Agent"];
}

- (void)extractorFailedWithMessage:(NSString*)message errorCode:(int)code {
    _running = NO;
    NSError *error = [NSError errorWithDomain:YTVimeoExtractorErrorDomain
                                         code:code
                                     userInfo:[NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey]];
    
    if (self.failure) {
        self.failure(error);
    }
    else if ([self.delegate respondsToSelector:@selector(vimeoExtractor:failedExtractingVimeoURLWithError:)]) {
        [self.delegate vimeoExtractor:self failedExtractingVimeoURLWithError:error];
    }
}

- (NSString *)playerURLFromHTML:(NSString *)html {
    __block NSString *url;
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\"//.*?\""
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    [regex enumerateMatchesInString:html
                            options:0
                              range:NSMakeRange(0, html.length)
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                           NSRange removedQuotesRange = NSMakeRange(result.range.location + 1, result.range.length - 2);
                           NSString *string = [html substringWithRange: removedQuotesRange];
                           
                           if ([string rangeOfString:@"redirect"].location != NSNotFound) {
                             url = string;
                           }
                         }];
    return url;
}

#pragma mark - NSURLConnectionDelegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSUInteger capacity;
    if (response.expectedContentLength != NSURLResponseUnknownLength)
        capacity = response.expectedContentLength;
    else
        capacity = 0;
    
    self.buffer = [[NSMutableData alloc] initWithCapacity:capacity];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.buffer appendData:data];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
    if ([request URL] && [[[redirectResponse URL] absoluteString] isEqualToString:self.playerURL]) {
        _streamURL = [request URL];
        // skip redirection
        return nil;
    }
    return request;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // handle first request
    if (!self.playerURL && ([self.buffer length] > 0)) {
        NSString *responseHTML = [[NSString alloc] initWithData:self.buffer encoding:NSUTF8StringEncoding];        
        if ([responseHTML length] <= 0) {
            [self extractorFailedWithMessage:@"Found Invalide HTML" errorCode:YTVimeoExtractorErrorCodeInvalidHTML];
            return;
        }
        self.playerURL = [self playerURLFromHTML:responseHTML];
      
        if (!self.playerURL || self.playerURL.length <= 20) {
          [self extractorFailedWithMessage:@"Found Invalid stream URL" errorCode:YTVimeoExtractorErrorCodeNotInitialized];
          return;
        }
        self.playerURL = [NSString stringWithFormat:@"https:%@", [self.playerURL substringWithRange:NSMakeRange(0, [self.playerURL length] - 20)]];
        
        // setup quality
        self.playerURL = [self.playerURL substringWithRange:NSMakeRange(0, [self.playerURL length] - 20)];
        
        if (self.quality == YTVimeoVideoQualityLow)
            self.playerURL = [self.playerURL stringByAppendingString:@"iphone"];
        else if (self.quality == YTVimeoVideoQualityMedium)
            self.playerURL = [self.playerURL stringByAppendingString:@"standard"];
        else if (self.quality == YTVimeoVideoQualityHigh)
            self.playerURL = [self.playerURL stringByAppendingString:@"high"];
        
        // run second request
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.playerURL]];
        [self setupRequest:&request];
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    }
    // handle second request
    else if (self.streamURL && ([self.buffer length] == 0)) {
        _running = NO;
        
        if (self.success) {
            self.success(self.streamURL);
        }
        else if ([self.delegate respondsToSelector:@selector(vimeoExtractor:didSuccessfullyExtractVimeoURL:)]) {
            [self.delegate vimeoExtractor:self didSuccessfullyExtractVimeoURL:self.streamURL];
        }
    }
    else {
        
        [self extractorFailedWithMessage:@"Found Invalid stream URL" errorCode:YTVimeoExtractorErrorCodeNoStreamURL];
        _running = NO;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self extractorFailedWithMessage:@"Cannot find live stream URL" errorCode:YTVimeoExtractorErrorCodeNoStreamURL];
}

@end
