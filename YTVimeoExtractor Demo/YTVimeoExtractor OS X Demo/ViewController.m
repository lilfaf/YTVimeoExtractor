//
//  ViewController.m
//  YTVimeoExtractor OS X Demo
//
//  Created by Soneé John on 12/14/15.
//  Copyright © 2015 Louis Larpin. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)playAction:(id)sender {
    [[YTVimeoExtractor sharedExtractor]fetchVideoWithVimeoURL:self.urlTextField.stringValue withReferer:nil completionHandler:^(YTVimeoVideo * _Nullable video, NSError * _Nullable error) {
        
        if (video) {
            
            [self.titleTextField setStringValue:video.title];
            
            //Will get the lowest available quality.
            //NSURL *lowQualityURL = [video lowestQualityStreamURL];
            
            //Will get the highest available quality.
            NSURL *highQualityURL = [video highestQualityStreamURL];
            
            AVPlayer *player = [[AVPlayer alloc]initWithURL:highQualityURL];
    
            self.playerView.player = player;
            self.playerView.videoGravity = AVLayerVideoGravityResizeAspectFill;
            [self.playerView.player play];
            [self.playerView becomeFirstResponder];
        
        }else{
            
            [[NSAlert alertWithError:error]runModal];
        }
        
    }];
}
@end
