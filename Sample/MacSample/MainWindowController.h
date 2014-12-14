//
//  MainWindowController.h
//  Sample
//
//  Created by Louis Larpin on 14/12/2014.
//  Copyright (c) 2014 Louis Larpin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

#import "YTVimeoExtractor.h"

@interface MainWindowController : NSWindowController
@property (weak) IBOutlet NSTextField *textURL;
@property (weak) IBOutlet NSSegmentedControl *qualitySeg;

- (IBAction)playVideo:(id)sender;
- (IBAction)changeQuality:(id)sender;
@end
