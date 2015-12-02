//
//  YTVimeoExtractorOperation.m
//  Sample
//
//  Created by Soneé Delano John on 11/28/15.
//  Copyright © 2015 Louis Larpin. All rights reserved.
//

#import "YTVimeoExtractorOperation.h"
#import "YTVimeoExtractor.h"


@interface YTVimeoExtractorOperation ()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, readonly) NSURLSession *networkSession;

@property (strong, nonatomic) NSMutableData *buffer;


@property (nonatomic, assign) BOOL isExecuting;
@property (nonatomic, assign) BOOL isFinished;

@property (nonatomic, readonly) NSString* referer;

@property (strong, nonatomic, readonly) NSURL *vimeoURL;

@end
@implementation YTVimeoExtractorOperation


-(instancetype)initWithVideoIdentifier:(NSString *)videoIdentifier referer:(NSString *)videoReferer{
    
    
    if (!(self = [super init]))
        return nil;
    
    _vimeoURL = [NSURL URLWithString:[NSString stringWithFormat:YTVimeoPlayerConfigURL, videoIdentifier]];
    
    // use given referer or default to vimeo domain
    if (videoReferer) {
        _referer = videoReferer;
    } else {
        _referer = [NSString stringWithFormat:YTVimeoURL, videoIdentifier];
    }

    return self;
}

#pragma mark - NSOperation

-(BOOL)isAsynchronous{
    
    return YES;
}
- (void) cancel
{
    if (self.isCancelled || self.isFinished)
        return;
    
    [super cancel];
    
    [self.dataTask cancel];
    
    [self finish];
}
-(void)start{
    
    if (self.isCancelled) {
        return;
    }
    
    self.isExecuting = YES;
    
    // build request headers
    NSMutableDictionary *sessionHeaders = [NSMutableDictionary dictionaryWithDictionary:@{@"Content-Type" : @"application/json"}];
    if (self.referer) {
        [sessionHeaders setValue:self.referer forKey:@"Referer"];
    }
    
    // configure the session
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    sessionConfig.HTTPAdditionalHeaders = sessionHeaders;
    
    _networkSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    // start the request
    self.dataTask = [self.networkSession dataTaskWithURL:self.vimeoURL];
    [self.dataTask resume];
    
}

+ (BOOL) automaticallyNotifiesObserversForKey:(NSString *)key
{
    SEL selector = NSSelectorFromString(key);
    return selector == @selector(isExecuting) || selector == @selector(isFinished) || [super automaticallyNotifiesObserversForKey:key];
}

- (void) finish
{
    self.isExecuting = NO;
    self.isFinished = YES;
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if (httpResponse.statusCode != 200) {
        // cancel the session
        [self finish];
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
    //send operation
    [self finish];
    if (error) {
        
    }else{
        
        // parse json from buffered data
        NSError *jsonError;
        __unused NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:self.buffer options:NSJSONReadingAllowFragments error:&jsonError];
    }
    
}
@end
