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
   
    XCTAssertThrowsSpecific([[YTVimeoVideo alloc]initWithIdentifier:nil info:nil], NSException, @"should throw an exception");

}

-(void)testThumbnails{
    
    NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"testdata.plist"];
    
    NSData *buffer = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *myDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:buffer];
    
    YTVimeoVideo *video = [[YTVimeoVideo alloc]initWithIdentifier:@"147318819" info:myDictionary];
    
            
    XCTAssertNotNil(video.thumbnailURLs);
    
}

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
#pragma mark -
- (void) testVideoObjectDescription
{
    NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"testdata.plist"];
   
    NSData *buffer = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *myDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:buffer];




    YTVimeoVideo *videoObject = [[YTVimeoVideo alloc]initWithIdentifier:@"147318819" info:myDictionary];
    //[147318819] Istanbul | Flow Through the City of Tales
    NSString *des = [NSString stringWithFormat:@"[%@] %@",videoObject.identifier, videoObject.title];
    
    if ([videoObject.description isEqualToString:des]) {
        
    }
    
    //XCTAssertTrue();
    XCTAssertEqualObjects(videoObject.description,des);
}

@end
