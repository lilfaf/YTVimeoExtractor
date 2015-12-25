//
//  ViewController.h
//  YTVimeoExtractor iOS Demo
//
//  Created by Soneé John on 12/14/15.
//  Copyright © 2015 Louis Larpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface ViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *urlField;
-(IBAction)playVideoAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

