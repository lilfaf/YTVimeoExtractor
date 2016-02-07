//
//  YTVimeoVideoTestCase.m
//  Sample
//
//  Created by Soneé Delano John on 12/2/15.
//  Copyright © 2015 Louis Larpin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YTVimeoVideo.h"
#import "YTVimeoExtractorOperation.h"
#import "YTVimeoError.h"
@interface YTVimeoVideoTestCase : XCTestCase

@end

@implementation YTVimeoVideoTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


#pragma mark - 
- (void)testWrongInitializer
{
    XCTAssertThrowsSpecificNamed([[YTVimeoVideo alloc] init], NSException, NSGenericException);
}

-(void)testNilParms{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wconversion"
#pragma clang diagnostic ignored "-Wnonnull"
   
    XCTAssertThrowsSpecific([[YTVimeoVideo alloc]initWithIdentifier:nil info:nil], NSException, @"should throw an exception");
    #pragma clang diagnostic pop

}

-(void)testNilCompletionHandler{
    NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"testdata.plist"];
    
    NSData *buffer = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *myDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:buffer];
    
    YTVimeoVideo *video = [[YTVimeoVideo alloc]initWithIdentifier:@"147318819" info:myDictionary];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wconversion"
#pragma clang diagnostic ignored "-Wnonnull"
    
    XCTAssertThrowsSpecificNamed([video extractVideoInfoWithCompletionHandler:nil],NSException, NSInvalidArgumentException);
    
    #pragma clang diagnostic pop
}


-(void)testThumbnails{
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@""];

    NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"testdata.plist"];
    
    NSData *buffer = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *myDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:buffer];
    
    YTVimeoVideo *video = [[YTVimeoVideo alloc]initWithIdentifier:@"147318819" info:myDictionary];
    
    [video extractVideoInfoWithCompletionHandler:^(NSError * _Nullable error) {
        
        XCTAssertNotNil(video.thumbnailURLs);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15 handler:nil];
}

-(void)testConvenienceMethods{
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"testdata.plist"];
    
    NSData *buffer = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *myDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:buffer];
    
    YTVimeoVideo *video = [[YTVimeoVideo alloc]initWithIdentifier:@"147318819" info:myDictionary];
    
    [video extractVideoInfoWithCompletionHandler:^(NSError * _Nullable error) {
        
        XCTAssertNotNil(video.streamURLs);
        
        NSURL *highestURL = video.streamURLs[@(YTVimeoVideoQualityHD1080)] ?: video.streamURLs[@(YTVimeoVideoQualityHD720)] ?: video.streamURLs [@(YTVimeoVideoQualityMedium480)]?: video.streamURLs[@(YTVimeoVideoQualityMedium360)]?:video.streamURLs[@(YTVimeoVideoQualityLow270)];
        
        NSURL *lowestURL = video.streamURLs[@(YTVimeoVideoQualityLow270)] ?: video.streamURLs[@(YTVimeoVideoQualityMedium360)] ?: video.streamURLs[@(YTVimeoVideoQualityMedium480)]?: video.streamURLs[@(YTVimeoVideoQualityHD720)]?:video.streamURLs[@(YTVimeoVideoQualityHD1080)];
        
        XCTAssertEqual(highestURL, [video highestQualityStreamURL]);
        
        XCTAssertEqual(lowestURL, [video lowestQualityStreamURL]);

        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15 handler:nil];
}

/*
-(void)testUnsuitableStreamThatAlsoHasSuitableStreams{
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    YTVimeoExtractorOperation *operation = [[YTVimeoExtractorOperation alloc]initWithVideoIdentifier:@"1373038" referer:nil];
    
    operation.completionBlock = ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
        
        YTVimeoVideo *video = [[YTVimeoVideo alloc]initWithIdentifier:@"1373038" info:operation.jsonDict];
        
#pragma clang diagnostic pop
        
        if (video.otherStreamURLs.count == 0 || video.otherStreamURLs == nil) {
            
            XCTFail(@"`otherStreamURLs` was not nil or empty. The Vimeo video has no `otherStreamURLs`. Try testing with a different video.");
            
        }else{
            
            XCTAssertNotNil(video.otherStreamURLs);
        }
        
        [expectation fulfill];
        
    };
    
    [operation start];
    
    [self waitForExpectationsWithTimeout:15 handler:nil];
}
 */
#pragma mark -
- (void) testVideoObjectDescription
{
    NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"testdata.plist"];
   
    NSData *buffer = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *myDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:buffer];

    YTVimeoVideo *videoObject = [[YTVimeoVideo alloc]initWithIdentifier:@"147318819" info:myDictionary];
    //[147318819] Istanbul | Flow Through the City of Tales
    NSString *des = [NSString stringWithFormat:@"[%@] %@",videoObject.identifier, videoObject.title];
    
    XCTAssertEqualObjects(videoObject.description,des);
}
#pragma mark - 
-(void)testPrivateVideo{
    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    YTVimeoExtractorOperation *operation = [[YTVimeoExtractorOperation alloc]initWithVideoIdentifier:@"148222047" referer:nil];
    
    operation.completionBlock = ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
        
        YTVimeoVideo *video = [[YTVimeoVideo alloc]initWithIdentifier:@"148222047" info:operation.jsonDict];
        
#pragma clang diagnostic pop
        
        [video extractVideoInfoWithCompletionHandler:^(NSError * _Nullable error) {
            
            XCTAssertTrue(error.domain == YTVimeoVideoErrorDomain);
            XCTAssertTrue(error.code == YTVimeoErrorRestrictedPlayback);
           
            
            [expectation fulfill];
        }];
        
        
    };
    
    [operation start];
    
    [self waitForExpectationsWithTimeout:15 handler:nil];
}

@end
