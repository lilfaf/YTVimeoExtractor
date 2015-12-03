//
//  YTVimeoURLParser.h
//  Sample
//
//  Created by Soneé Delano John on 12/2/15.
//  Copyright © 2015 Louis Larpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTVimeoURLParser : NSObject
/**
 *  Checks to see if a given URL is a valid Vimeo URL. In additonal, this will determine if it can be handled by the `YTVimeoExtractorOperation` class.
 *
 *  @param vimeoURL The Vimeo URL that will be validated.
 *
 *  @return `YES`if URL is valid. Otherwise `NO``
 */
- (BOOL)validateVimeoURL:(NSString *)vimeoURL;
@end
