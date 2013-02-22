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

Create an instance of YTVimeoExtractor and pass it the video url and the desired quality.

```objc
self.extractor = [[YTVimeoExtractor alloc] initWithURL:@"http://vimeo.com/58600663" quality:YTVimeoVideoQualityMedium];
self.extractor.delegate = self;
[self.extractor start];
```

Then implement YTVimeoExtractor delegate methods in your ViewController.

```objc
- (void)vimeoExtractor:(YTVimeoExtractor *)extractor didSuccessfullyExtractVimeoURL:(NSURL *)videoURL
{
    self.playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    [self.playerViewController.moviePlayer prepareToPlay];
    [self presentViewController:self.playerViewController animated:YES completion:nil];
}

- (void)vimeoExtractor:(YTVimeoExtractor *)extractor failedExtractingVimeoURLWithError:(NSError *)error;
{
    // handle error
}
```

Check the sample application for more details.

## Requirements

YTVimeoExtractor requires iOS 4.0 and above as it is deployed for an ARC environment.

## License

YTVimeoExtractor is licensed under the MIT License. See the LICENSE file for details.
