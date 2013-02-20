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

- (void)runPlayer:(NSURL *)url;
- (void)playerViewDidExitFullScreen;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.quality = YTVimeoVideoQualityLow;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)playVideo:(id)sender {
    self.extractor = [[YTVimeoExtractor alloc] initWithURL:self.textURL.text
                                                   quality:self.quality];
    self.extractor.delegate = self;
    [_extractor start];
}

- (IBAction)changeQuality {
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

#pragma mark - YTVimeoExtractorDelegate

- (void)vimeoExtractor:(YTVimeoExtractor *)extractor didSuccessfullyExtractVimeoURL:(NSURL *)videoURL
{
    NSLog(@"Extracted url : %@", [videoURL absoluteString]);
    extractor = nil;
    if (!_fullScreen)
        [self runPlayer:videoURL];
}

- (void)vimeoExtractor:(YTVimeoExtractor *)extractor failedExtractingVimeoURLWithError:(NSError *)error;
{
    NSLog(@"ERROR: %@", [error localizedDescription]);
}

#pragma mark - Private

- (void)runPlayer:(NSURL *)url
{
    _fullScreen = YES;
    
    // wrap controller initialization call in an artificial drawing context
    // to avoid invalid context error messages
    
    UIGraphicsBeginImageContext(CGSizeMake(1,1));
    
    self.playerView = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    
    UIGraphicsEndImageContext();
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerViewDidExitFullScreen)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.playerView.moviePlayer];
    
    [self.playerView.moviePlayer prepareToPlay];
    [self.playerView.view setFrame:self.view.frame];
    
    [self presentMoviePlayerViewControllerAnimated:self.playerView];
}

- (void)playerViewDidExitFullScreen
{
    _fullScreen = NO;
}

@end
