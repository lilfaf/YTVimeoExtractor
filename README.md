## YTVimeoExtractor

YTVimeoExtractor helps you get mp4 urls which can be use in iOS's native player. You can even choose between mobile, standard and high definition quality.

YTVimeoExtractor doesn't use UIWebView which makes it fast and clean.

## Install

The preferred way of installation is via [CocoaPods](http://cocoapods.org). Just add to your Podfile

```ruby
pod 'YTVimeoExtractor'
```

and run `pod install`.

Alternatively you can just copy the YTVimeoExtractor folder to your project.

```objc
#import "YTVimeoExtractor.h"
```

## Usage

Use the block based methods and pass it the video url and the desired quality

```objc
[YTVimeoExtractor fetchVideoURLFromURL:@"http://vimeo.com/58600663"
                               quality:YTVimeoVideoQualityHD1080
                     completionHandler:^(NSURL *videoURL, NSError *error, YTVimeoVideoQuality quality) {
    if (error) {
    	// handle error
    	NSLog(@"Video URL: %@", [videoURL absoluteString]);
	} else {
        // run player
        dispatch_async (dispatch_get_main_queue(), ^{
            self.playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
            [self.playerViewController.moviePlayer prepareToPlay];
            [self presentViewController:self.playerViewController animated:YES completion:nil];
       });
	}
}];
```

or create an instance of YTVimeoExtractor.

```objc
self.extractor = [[YTVimeoExtractor alloc] initWithURL:@"http://vimeo.com/58600663" quality:YTVimeoVideoQualityHD1080];
self.extractor.delegate = self;
[self.extractor start];
```

and implement YTVimeoExtractor delegate methods in your ViewController.

```objc
- (void)vimeoExtractor:(YTVimeoExtractor *)extractor didSuccessfullyExtractVimeoURL:(NSURL *)videoURL withQuality:(YTVimeoVideoQuality)quality
{
    // handle success
}

- (void)vimeoExtractor:(YTVimeoExtractor *)extractor failedExtractingVimeoURLWithError:(NSError *)error;
{
    // handle error
}
```

If the Vimeo videos have domain-level restrictions and can only be played from particular domains, it's easy to add a referer:

```objc
[YTVimeoExtractor fetchVideoURLFromURL:@"http://vimeo.com/58600663"
                               quality:YTVimeoVideoQualityHD1080
                               referer:@"http://www.mywebsite.com"
                     completionHandler:^(NSURL *videoURL, NSError *error, YTVimeoVideoQuality quality) {
    if (error) {
        // handle error
        NSLog(@"Video URL: %@", [videoURL absoluteString]);
    } else {
        // run player
        dispatch_async (dispatch_get_main_queue(), ^{
          self.playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
          [self.playerViewController.moviePlayer prepareToPlay];
          [self presentViewController:self.playerViewController animated:YES completion:nil];
        });
    }
}];
```

Check the sample application for more details.

## Requirements

YTVimeoExtractor requires iOS 7.0 and above as it is deployed for an ARC environment.

## License

YTVimeoExtractor is licensed under the MIT License. See the LICENSE file for details.
