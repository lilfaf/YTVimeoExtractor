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
    
    self.quality = YTVimeoVideoQualityBestAvailable;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)playVideo:(id)sender
{
    [YTVimeoExtractor fetchVideoURLFromURL:self.textURL.text quality:self.quality completionHandler:^(NSURL *videoURL, NSError *error, YTVimeoVideoQuality quality) {
        if (error) {
            NSLog(@"Error : %@", [error localizedDescription]);
        } else if (videoURL) {
            NSLog(@"Extracted url : %@", [videoURL absoluteString]);
            NSLog(@"Extracted with quality : %@", @[@"Low", @"Medium", @"HD 720", @"HD 1080"][quality]);

            dispatch_async (dispatch_get_main_queue(), ^{
                self.playerView = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
                [self.playerView.moviePlayer prepareToPlay];
                [self presentViewController:self.playerView animated:YES completion:^(void) {
                    self.playerView = nil;
                }];
            });
        }
    }];
}

- (IBAction)printMetadata:(id)sender {
    [YTVimeoExtractor fetchVideoMetadataFromURL:self.textURL.text quality:self.quality completionHandler:^(NSURL *videoURL, NSDictionary *metadata, NSError *error, YTVimeoVideoQuality quality) {
        if (error) {
            NSLog(@"Error : %@", [error localizedDescription]);
        } else if (videoURL) {
            NSLog(@"Extracted url : %@", [videoURL absoluteString]);
            NSLog(@"Extracted metadata: %@", metadata);
        }
    }];
}

- (IBAction)changeQuality
{
    switch (self.qualitySeg.selectedSegmentIndex) {
        case 0:
            self.quality = YTVimeoVideoQualityLow270;
            break;
        case 1:
            self.quality = YTVimeoVideoQualityMedium360;
            break;
        case 2:
            self.quality = YTVimeoVideoQualityHigh;
        case 3:
            self.quality = YTVimeoVideoQualityHD;
        default:
            self.quality = YTVimeoVideoQualityBestAvailable;
            break;
    }
}

@end
