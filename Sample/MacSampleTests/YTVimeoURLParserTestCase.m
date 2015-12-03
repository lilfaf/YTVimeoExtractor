//
//  YTVimeoURLParserTestCase.m
//  Sample
//
//  Created by Soneé Delano John on 12/2/15.
//  Copyright © 2015 Louis Larpin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YTVimeoURLParser.h"
@interface YTVimeoURLParserTestCase : XCTestCase

@end

@implementation YTVimeoURLParserTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark -
-(void)testValidVimeoURL{
    
    YTVimeoURLParser *parser = [[YTVimeoURLParser alloc]init];
    XCTAssertTrue([parser validateVimeoURL:@"https://vimeo.com/145706460"]);
}

-(void)testValidVimeoURL_StaffPicks{
    YTVimeoURLParser *parser = [[YTVimeoURLParser alloc]init];
    XCTAssertTrue([parser validateVimeoURL:@"https://vimeo.com/channels/staffpicks/147365861"]);

}

-(void)testValidVimeoURL_Groups{
    
    YTVimeoURLParser *parser = [[YTVimeoURLParser alloc]init];
    XCTAssertTrue([parser validateVimeoURL:@"https://vimeo.com/groups/travelhd/videos/147536447"]);
}

-(void)testValidVimeoURL_Album{
    
    YTVimeoURLParser *parser = [[YTVimeoURLParser alloc]init];
    XCTAssertTrue([parser validateVimeoURL:@"https://vimeo.com/album/3643712/video/59749737"]);
}

#pragma mark -
-(void)testInvalidVimeoURL_nilParm{
    
    YTVimeoURLParser *parser = [[YTVimeoURLParser alloc]init];
    XCTAssertFalse([parser validateVimeoURL:nil]);
}

-(void)testInvalidVimeoURL_EmptyString{
    
    YTVimeoURLParser *parser = [[YTVimeoURLParser alloc]init];
    XCTAssertFalse([parser validateVimeoURL:@""]);
}

-(void)testInvalidVimeoURL_NonNumeric{
    
    YTVimeoURLParser *parser = [[YTVimeoURLParser alloc]init];
    XCTAssertFalse([parser validateVimeoURL:@"https://vimeo.com/album/3643712/video/AAAAAA"]);
}


@end
