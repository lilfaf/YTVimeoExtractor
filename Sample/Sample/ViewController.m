//
//  ViewController.m
//  Sample
//
//  Created by Louis on 18/02/13.
//  Copyright (c) 2013 Louis Larpin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) YTVimeoExtractor *extractor;
@property (strong, nonatomic) MPMoviePlayerViewController *playerView;
@property (nonatomic) YTVimeoVideoQuality quality;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.quality = YTVimeoVideoQualityMedium;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)playVideo:(id)sender
{
    [YTVimeoExtractor fetchVideoURLFromURL:self.textURL.text quality:self.quality completionHandler:^(NSURL *videoURL, NSString* title, NSError *error, YTVimeoVideoQuality quality) {
        if (error) {
            NSLog(@"Error : %@", [error localizedDescription]);
        } else if (videoURL) {
            NSLog(@"Extracted url : %@, title: %@", [videoURL absoluteString], title);
            
            self.playerView = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
            [self.playerView.moviePlayer prepareToPlay];
            [self presentViewController:self.playerView animated:YES completion:^(void) {
                self.playerView = nil;
            }];
        }
    }];
}

- (IBAction)changeQuality
{
    switch (self.qualitySeg.selectedSegmentIndex) {
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
