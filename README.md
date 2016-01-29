## YTVimeoExtractor

<<<<<<< HEAD
[![Build Status](https://travis-ci.org/lilfaf/YTVimeoExtractor.svg?branch=development)](https://travis-ci.org/lilfaf/YTVimeoExtractor)
=======
[![Build Status](https://travis-ci.org/lilfaf/YTVimeoExtractor.svg?branch=master)](https://travis-ci.org/lilfaf/YTVimeoExtractor)
[![Carthage
compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
>>>>>>> master

YTVimeoExtractor extracts the MP4 streams of Vimeo videos, which then can be used to play via a `MPMoviePlayerViewController` or `AVPlayerView`.

 <img src="Screenshots/iphone_screenshot.PNG" width="600" height="331">

## Requirements
- Runs on iOS 7.0 and later
- Runs on OS X 10.9 and later
- Runs on tvOS 9.0 and later

## Overview of Library

| Class         | Purpose        |
|---------------|----------------|
| `YTVimeoExtractor`  |   The `YTVimeoExtractor` is the main class and its sole purpose is to fetch information about Vimeo videos. Use the two main methods `fetchVideoWithIdentifier:withReferer:completionHandler:` or `fetchVideoWithVimeoURL:withReferer:completionHandler:` to obtain video information.  |
| `YTVimeoExtractorOperation`  |   `YTVimeoExtractorOperation` is a subclass of `NSOperation` and is used to fetch and parse out information about Vimeo videos. This a low level class. Generally speaking, you should use the higher level `YTVimeoExtractor` class.   |
|`YTVimeoURLParser`			    |	`YTVimeoURLParser` is used to validate and parse put Vimeo URLs. The sole purpose of the class is to check if a given URL can be handled by the `YTVimeoExtractor` class.|
|`YTVimeoVideo`|  	`YTVimeoVideo` represents a Vimeo video. Use this class to access information about a particular video. Generally, you should not initialize this class, instead use the two main methods of the `YTVimeoExtractor` class.|

## Installation

### CocoaPods

The preferred way of installation is via [CocoaPods](http://cocoapods.org). Just add to your Podfile

```ruby
pod 'YTVimeoExtractor'
```

and run `pod install`.

Alternatively you can just copy the YTVimeoExtractor folder to your project.

```objc
#import "YTVimeoExtractor.h"
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency
manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following
command:

```bash
$ brew update
$ brew install carthage
```

To integrate YTVimeoExtractor into your Xcode project using Carthage, specify it in
your `Cartfile`:

```ogdl
github "lilfaf/YTVimeoExtractor"
```

Run `carthage` to build the framework and drag the built
`YTVimeoExtractor.framework` into your Xcode project.

## Usage

Use the two block methods in the `YTVimeoExtractor` class. Both methods will call a completionHandler which is executed on the main thread. If the completion handler is nil, an exception will be thrown. The completionHandler has, two parameters a `YTVimeoVideo` object, if the operation was completed successfully, and a `NSError` object describing the network or parsing error that may have occurred.

### OS X Example

```objc
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


```

### iOS Example

```objc

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
 ```
 
### Referer Example
If the Vimeo video has domain-level restrictions and can only be played from particular domains, it's easy to add a referer:

```objc

 [[YTVimeoExtractor sharedExtractor]fetchVideoWithVimeoURL:@"https://vimeo.com/channels/staffpicks/147876560" withReferer:@"http://www.mywebsite.com" completionHandler:^(YTVimeoVideo * _Nullable video, NSError * _Nullable error) {
        
        if (video) {
            
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
 ```
 
## Acknowledgments

* YTVimeoExtractor was originally created by [Louis Larpin](https://github.com/lilfaf)
* Reorganization, documentation, and Unit Tests were done by [Soneé John](https://github.com/SoneeJohn)
* Special thanks to all who [contributed](https://github.com/lilfaf/YTVimeoExtractor/graphs/contributors) to the project.

## License

YTVimeoExtractor is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

--------
###### YTVimeoExtractor is against the Vimeo [Terms of Service](https://vimeo.com/terms). 
