//
//  YTVimeoExtractorTestCase.m
//  YTVimeoExtractor
//
//  Created by Soneé John on 12/13/15.
//  Copyright © 2015 Louis Larpin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YTVimeoExtractor.h"
@interface YTVimeoExtractorTestCase : XCTestCase

@end

@implementation YTVimeoExtractorTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
-(void)testNilCompletionHandler{
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wconversion"
#pragma clang diagnostic ignored "-Wnonnull"
    
    XCTAssertThrowsSpecificNamed([[YTVimeoExtractor sharedExtractor]fetchVideoWithIdentifier:@"" withReferer:nil completionHandler:nil],NSException, NSInvalidArgumentException);
    
    XCTAssertThrowsSpecificNamed([[YTVimeoExtractor sharedExtractor]fetchVideoWithVimeoURL:@"" withReferer:nil completionHandler:nil],NSException, NSInvalidArgumentException);
    #pragma clang diagnostic pop


}
-(void)testInvalidID_Nil{
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wconversion"
#pragma clang diagnostic ignored "-Wnonnull"
    
    XCTAssertThrowsSpecific([[YTVimeoExtractor sharedExtractor]fetchVideoWithIdentifier:nil withReferer:nil completionHandler:^(YTVimeoVideo * _Nullable video, NSError * _Nullable error) {
        
    }],NSException);
    
    XCTAssertThrowsSpecific([[YTVimeoExtractor sharedExtractor]fetchVideoWithVimeoURL:nil withReferer:nil completionHandler:^(YTVimeoVideo * _Nullable video, NSError * _Nullable error) {
        
    }],NSException);
#pragma clang diagnostic pop
    
}

-(void)testInvalidID_EmptyString{
    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    [[YTVimeoExtractor sharedExtractor]fetchVideoWithIdentifier:@"" withReferer:nil completionHandler:^(YTVimeoVideo * _Nullable video, NSError * _Nullable error) {
        
        XCTAssertNil(video);
        XCTAssertTrue(error.domain == YTVimeoVideoErrorDomain);
        XCTAssertTrue(error.code == YTVimeoErrorInvalidVideoIdentifier);
        
        [[YTVimeoExtractor sharedExtractor]fetchVideoWithVimeoURL:@"" withReferer:nil completionHandler:^(YTVimeoVideo * _Nullable video, NSError * _Nullable error) {
            
            XCTAssertNil(video);
            XCTAssertTrue(error.domain == YTVimeoVideoErrorDomain);
            XCTAssertTrue(error.code == YTVimeoErrorInvalidVideoIdentifier);
            
            [expectation fulfill];
        }];
        
    }];

     [self waitForExpectationsWithTimeout:15 handler:nil];
    
}

-(void)testInvalidID{

    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@""];
            
        [[YTVimeoExtractor sharedExtractor]fetchVideoWithVimeoURL:@"https://vimeo.com/ondemand/almostthere" withReferer:nil completionHandler:^(YTVimeoVideo * _Nullable video, NSError * _Nullable error) {
            
            XCTAssertNil(video);
            XCTAssertTrue(error.domain == YTVimeoVideoErrorDomain);
            XCTAssertTrue(error.code == YTVimeoErrorInvalidVideoIdentifier);
            
            [expectation fulfill];
        }];
        
    
    
    [self waitForExpectationsWithTimeout:15 handler:nil];
    
}
-(void)testPrivateVideo{
    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    
    [[YTVimeoExtractor sharedExtractor]fetchVideoWithIdentifier:@"148222047" withReferer:nil completionHandler:^(YTVimeoVideo * _Nullable video, NSError * _Nullable error) {
        
        XCTAssertNil(video);
        XCTAssertTrue(error.domain == YTVimeoVideoErrorDomain);
        XCTAssertTrue(error.code == YTVimeoErrorRestrictedPlayback);
        
        [[YTVimeoExtractor sharedExtractor]fetchVideoWithVimeoURL:@"https://www.vimeo.com/148222047" withReferer:nil completionHandler:^(YTVimeoVideo * _Nullable video, NSError * _Nullable error) {
            
            XCTAssertNil(video);
            XCTAssertTrue(error.domain == YTVimeoVideoErrorDomain);
            XCTAssertTrue(error.code == YTVimeoErrorRestrictedPlayback);
            
            [expectation fulfill];
        }];
        
    }];

    
    [self waitForExpectationsWithTimeout:15 handler:nil];
}

-(void)testdeletedVideo{
    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    
    [[YTVimeoExtractor sharedExtractor]fetchVideoWithIdentifier:@"50242109" withReferer:nil completionHandler:^(YTVimeoVideo * _Nullable video, NSError * _Nullable error) {
        
        XCTAssertNil(video);
        XCTAssertTrue(error.domain == YTVimeoVideoErrorDomain);
        XCTAssertTrue(error.code == YTVimeoErrorRemovedVideo);
        
        [[YTVimeoExtractor sharedExtractor]fetchVideoWithVimeoURL:@"https://www.vimeo.com/50242109" withReferer:nil completionHandler:^(YTVimeoVideo * _Nullable video, NSError * _Nullable error) {
            
            XCTAssertNil(video);
            XCTAssertTrue(error.domain == YTVimeoVideoErrorDomain);
            XCTAssertTrue(error.code == YTVimeoErrorRemovedVideo);
            
            [expectation fulfill];
        }];
        
    }];
    
    
    [self waitForExpectationsWithTimeout:15 handler:nil];
}

-(void)testNormalVideo{
   
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    
    [[YTVimeoExtractor sharedExtractor]fetchVideoWithIdentifier:@"147758866" withReferer:nil completionHandler:^(YTVimeoVideo * _Nullable video, NSError * _Nullable error) {
        
        XCTAssertNotNil(video);
        XCTAssertNil(error);
        
        [[YTVimeoExtractor sharedExtractor]fetchVideoWithVimeoURL:@"https://www.vimeo.com/147758866" withReferer:nil completionHandler:^(YTVimeoVideo * _Nullable video, NSError * _Nullable error) {
            
            XCTAssertNotNil(video);
            XCTAssertNil(error);
            
            [expectation fulfill];
        }];
        
    }];
    
    
    [self waitForExpectationsWithTimeout:15 handler:nil];
    
}


@end
