//
//  ViewController.h
//  Sample
//
//  Created by Louis on 18/02/13.
//  Copyright (c) 2013 Louis Larpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "YTVimeoExtractor.h"

@interface ViewController : UIViewController <YTVimeoExtractorDelegate>

@property (nonatomic, readonly) BOOL fullScreen;

@property (weak, nonatomic) IBOutlet UITextField *textURL;
@property (weak, nonatomic) IBOutlet UISegmentedControl *qualitySeg;

- (IBAction)playVideo:(id)sender;
- (IBAction)changeQuality;

@end
