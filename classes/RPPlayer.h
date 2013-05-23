//
//  RPPlayer.h
//  Danceplanet
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface RPPlayer : AVPlayer {
    //__strong RACBehaviorSubject *_currentTimeSignal;
    //__strong RACBehaviorSubject *_durationSignal;
    
    NSTimeInterval _currentTimeInterval;
}

@property (strong) NSURL *urlOfMedia;

@property (strong) id playbackObserver;

@property CMTime duration;
@property NSTimeInterval currentTimeInterval;
@property NSTimeInterval durationInterval;


@property (strong) RACSignal *currentTimeSignal;
@property (strong) RACSignal *durationSignal;
@property (strong) RACSignal *currentTimeIntervalSignal;
@property (strong) RACSignal *durationIntervalSignal;

+ (id)playerWithURL:(NSURL *)URL;

@end
