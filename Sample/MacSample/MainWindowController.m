//
//  MainWindowController.m
//  Sample
//
//  Created by Louis Larpin on 14/12/2014.
//  Copyright (c) 2014 Louis Larpin. All rights reserved.
//

#import "MainWindowController.h"

@interface MainWindowController ()

@property (nonatomic) AVPlayer *videoPlayer;
@property (weak) IBOutlet AVPlayerView *playerView;


@property (strong, nonatomic) YTVimeoExtractor *extractor;
@property (nonatomic) YTVimeoVideoQuality quality;

@end

@implementation MainWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.quality = YTVimeoVideoQualityMedium;
}

- (void)windowWillClose:(NSNotification *)notification {
    [self.videoPlayer pause];
    [self.playerView removeFromSuperviewWithoutNeedingDisplay];
    self.videoPlayer = nil;
    self.playerView = nil;
}

- (IBAction)playVideo:(id)sender {
    [YTVimeoExtractor fetchVideoURLFromURL:self.textURL.stringValue quality:self.quality completionHandler:^(NSURL *videoURL, NSError *error, YTVimeoVideoQuality quality) {
        if (error) {
            NSLog(@"Error : %@", [error localizedDescription]);
        } else if (videoURL) {
            NSLog(@"Extracted url : %@", [videoURL absoluteString]);
            
            self.videoPlayer = [[AVPlayer alloc] initWithURL:videoURL];
            self.playerView.player = self.videoPlayer;
            [self.videoPlayer play];
        }
    }];
}

- (IBAction)changeQuality:(id)sender {
    switch (self.qualitySeg.selectedSegment) {
        case 0:
            self.quality = YTVimeoVideoQualityLow;
            break;
        case 1:
            self.quality = YTVimeoVideoQualityMedium;
            break;
        case 2:
            self.quality = YTVimeoVideoQualityHigh;
            
        default:
            break;
    }
}
@end
