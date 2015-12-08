//
//  YTVimeoExtractorOperationTestCase.m
//  Sample
//
//  Created by Soneé John on 12/7/15.
//  Copyright © 2015 Louis Larpin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YTVimeoExtractorOperation.h"
#import "YTVimeoError.h"
@interface YTVimeoExtractorOperationTestCase : XCTestCase

@end

@implementation YTVimeoExtractorOperationTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark -
- (void)testInvalidInitialization{
    
    XCTAssertThrowsSpecificNamed([[YTVimeoExtractorOperation alloc] init], NSException, NSGenericException);
}

-(void)testNilParm{
    
    XCTAssertThrowsSpecific([[YTVimeoExtractorOperation alloc]initWithVideoIdentifier:nil referer:nil], NSException, @"should throw an exception");
    
}

#pragma mark -
- (void)testIsAsynchronous{
    YTVimeoExtractorOperation *operation = [[YTVimeoExtractorOperation alloc]initWithVideoIdentifier:@"9845854" referer:nil];
    XCTAssertTrue(operation.isAsynchronous);
}

-(void)testIsReady{
    
    YTVimeoExtractorOperation *operation = [[YTVimeoExtractorOperation alloc]initWithVideoIdentifier:@"9845854" referer:nil];
    //Operation should start at a ready state
    XCTAssertTrue(operation.isReady);
    
}

-(void)testCancellation{

    YTVimeoExtractorOperation *operation = [[YTVimeoExtractorOperation alloc]initWithVideoIdentifier:@"1373038" referer:nil];
    [operation start];
    [operation cancel];
    XCTAssertTrue(operation.isCancelled);
    XCTAssertTrue(operation.isFinished);
    XCTAssertFalse(operation.isExecuting);

}

-(void)testNormalCompletion{
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@""];

    YTVimeoExtractorOperation *operation = [[YTVimeoExtractorOperation alloc]initWithVideoIdentifier:@"1373038" referer:nil];
    
    [operation start];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
    operation.completionBlock = ^(){
        
        XCTAssertTrue(operation.isFinished);
        XCTAssertFalse(operation.isExecuting);
        [expectation fulfill];
    };
    
    
#pragma clang diagnostic pop

    [self waitForExpectationsWithTimeout:15 handler:nil];
  
}

#pragma mark - 
-(void)testdeletedVideo{
    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@""];


    YTVimeoExtractorOperation *operation = [[YTVimeoExtractorOperation alloc]initWithVideoIdentifier:@"50242109" referer:nil];
    
    [operation start];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
    operation.completionBlock = ^(){
        
        XCTAssertTrue(operation.error.code == YTVimeoErrorRemovedVideo);
        XCTAssertTrue(operation.error.domain == YTVimeoVideoErrorDomain);

        [expectation fulfill];
    };
    
    
#pragma clang diagnostic pop
    
    [self waitForExpectationsWithTimeout:15 handler:nil];

    
}


@end
