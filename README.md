ReactiveMediaPlayer
===================

A ReactiveCocoa-powered media player for iOS

![ScreenShot](/Screenshots/screenshot1.png)

### Intro

ReactiveMediaPlayer offers a lightweight, powerful, and aesthetically-pleasing UIView subclass to play videos and music in your app. It includes beautifully designed default controls inspired by the look and feel of Apple's own music apps. It's core functionality is a refined and useful wrapper for AVFoundation which includes nice subclasses of AVPlayer and AVPlayerLayer. It has none of the limitations of MPMusicPlayerController...you can use it full screen, or you can position it as an adorable little square like you would any other UIView.

*NOTE:* This library is built using ReactiveCocoa and ReactiveCocoaLayout. Many of it's APIs are offered as ReactiveCocoa signals, so if you're not a ReactiveCocoa user, you might want to look elsewhere for a media player project. 

### Features:

Easy access to AVPlayer/AVPlayerItem properties **currentTime** and **duration**.

```
CMTime playheadCurrentTime = videoPlay.player.currentTime;
NSTimeInterval playheadCurrentTimeInterval = videoPlay.player.currentTimeInterval;

// or

RACSignal *playheadCurrentTimeSignal = videoPlay.player.currentTimeSignal;
RACSignal *playheadCurrentTimeIntervalSignal = videoPlay.player.currentTimeIntervalSignal;
```
Conversions between CMTime, NSTimeInterval, and human readable integers. I offer you signals to pull user-friendly hours, minutes, and seconds from the playhead, seekbar, and media items. No need to mess around with CoreMedia's `CMTime` if you don't want to.


```
RACSignal *durationMinutesSignal = videoPlay.player.durationSignal.readableMinutesRoundedDown;
```


RMP makes it easy to size itself to a video clip, even after you've scaled it. It's `RACSignals` give you easy access to a video item's original dimensions, then using included RAC extensions, you can create a stream of new dimensions that honor aspect ratio.

```
RAC(videoPlayer,maxSize) = [RACSignal if:[self.interfaceOrientationSignal map:^id(NSNumber *interfaceOrientation) {
        return @(UIInterfaceOrientationIsPortrait(interfaceOrientation.integerValue));
    }] then:[RACSignal return:[NSValue valueWithCGSize:CGSizeMake(280, 280)]]
       else:[RACSignal return:[NSValue valueWithCGSize:CGSizeMake(400, 280)]]];

RAC(videoPlayer,rcl_bounds) = [RACSignal rectsWithSize:[videoPlayer.videoScaledSizeSignal startWith:MEDBox(videoPlayer.maxSize)]];
```

Helpful attributes and modes that describe the state of the player so you can customize it's controls in response to user action. Information such as `playing / paused / buffering`, `unstarted / started`, `tapped`.

```
[videoPlayer.modeSignal subscribeNext:^(NSNumber *modeNum){
	ReactiveMediaPlayerMode mode = modeNum.integerValue;
	if (ReactiveMediaPlayerMode == ReactiveMediaPlayerModePaused) {
       
      // Do something wonderful.

    };
}];
```
#### Contributions and pull requests welcome.