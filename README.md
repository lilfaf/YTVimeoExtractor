## YTVimeoExtractor

YTVimeoExtractor helps you get a live streaming url from Vimeo which can be use in iOS's native player. You can even choose between mobile, standard and high definition quality.

YTVimeoExtractor doesn't use UIWebView which makes it fast and clean.

---

### Install

Just copy the YTVimeoExtractor folder to your project.

It should be available via CocoaPods soon.

```objc
#import "YTVimeoExtractor.h"
```

## Usage

Create an instance of YTVimeoExtractor and pass it the video url and the desired quality.

```objc
self.extractor = [[YTVimeoExtractor alloc] initWithURL:@"http://vimeo.com/58600663" 
																							 quality:YTVimeoVideoQualityMedium];
self.extractor.delegate = self;
[_extractor start];
```

Then implement YTVimeoExtractor delegate methods in your ViewController.

```objc
- (void)vimeoExtractor:(YTVimeoExtractor *)extractor didSuccessfullyExtractVimeoURL:(NSURL *)videoURL
{
    self.moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    [self presentViewController:_moviePlayerController animated:YES completion:nil];
}

- (void)vimeoExtractor:(YTVimeoExtractor *)extractor failedExtractingVimeoURLWithError:(NSError *)error;
{
    // handle error
}
```

Check the sample application for more details.

---

## Requirements

YTVimeoExtractor requires iOS 5.X and above as it is deployed for an ARC environment.

---

## License

YTVimeoExtractor is licensed under the MIT License. See the LICENSE file for details.