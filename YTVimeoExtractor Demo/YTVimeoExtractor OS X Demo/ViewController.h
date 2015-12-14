//
//  ViewController.h
//  YTVimeoExtractor OS X Demo
//
//  Created by Soneé John on 12/14/15.
//  Copyright © 2015 Louis Larpin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <YTVimeoExtractor/YTVimeoExtractor.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@interface ViewController : NSViewController

- (IBAction)playAction:(id)sender;
@property (weak) IBOutlet NSTextField *urlTextField;
@property (weak) IBOutlet AVPlayerView *playerView;
@property (weak) IBOutlet NSTextField *titleTextField;

@end

