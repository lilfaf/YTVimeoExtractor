//
//  ViewController.m
//  YTVimeoExtractor iOS Demo
//
//  Created by Soneé John on 12/14/15.
//  Copyright © 2015 Louis Larpin. All rights reserved.
//

#import "ViewController.h"
#import "YTVimeoExtractor.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.urlField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
-(IBAction)playVideoAction:(id)sender{
    
    [[YTVimeoExtractor sharedExtractor]fetchVideoWithVimeoURL:self.urlField.text withReferer:nil completionHandler:^(YTVimeoVideo * _Nullable video, NSError * _Nullable error) {
        
        if (video) {
            
            self.titleLabel.text = [NSString stringWithFormat:@"Video Title: %@",video.title];
            //Will get the lowest available quality.
            //NSURL *lowQualityURL = [video lowestQualityStreamURL];
            
            //Will get the highest available quality.
            NSURL *highQualityURL = [video highestQualityStreamURL];
            
            MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:highQualityURL];

            [self presentMoviePlayerViewControllerAnimated:moviePlayerViewController];
        }else{
           
            UIAlertView *alertView = [[UIAlertView alloc]init];
            alertView.title = error.localizedDescription;
            alertView.message = error.localizedFailureReason;
            [alertView addButtonWithTitle:@"OK"];
            alertView.delegate = self;
            [alertView show];
            
        }
        
    }];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}



@end
