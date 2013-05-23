//
//  RPPlayer.m
//  Danceplanet
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import "RPPlayer.h"
#import "EXTScope.h"

@implementation RPPlayer

- (id)init
{
    self = [super init];
    if (self) {
        // init
        @weakify(self);
        
        
        
//        [RACAbleWithStart(self,currentItem.status) subscribeNext:^(id x) {
//            NSLog(@"hullo %@",x);
//        }];
//        [RACAbleWithStart(self,currentItem) subscribeNext:^(id x) {
//            NSLog(@"KUNTA KINTE %@",x);
//        }];

        RAC(self,duration) = [[[RACAbleWithStart(self,currentItem) filter:^BOOL(AVPlayerItem *item) {
            return (item);
        }] map:^id(AVPlayerItem *item) {
            
           // if (item) {
               // NSLog(@"current item changed %f",CMTimeGetSeconds(item.duration));
           //     return [NSValue valueWithCMTime:item.duration];
           // }
           // return [NSValue valueWithCMTime:kCMTimeInvalid];
            return [NSValue valueWithCMTime:item.duration];
        }] distinctUntilChanged];
        
        
        self.currentTimeSignal = [RACBehaviorSubject behaviorSubjectWithDefaultValue:[NSValue valueWithCMTime:self.currentTime]];
        self.durationSignal = RACAbleWithStart(self,duration);
        
        
        
        self.currentTimeIntervalSignal = [[self.currentTimeSignal map:^id(NSValue *value) {
            return [NSNumber numberWithDouble:CMTimeGetSeconds(value.CMTimeValue)];
        }] distinctUntilChanged];

        
        RAC(self,durationInterval) = [self.durationSignal
                                       map:^id(NSValue *duration) {
                                           NSNumber *durationInterval = @-1;
                                           if (CMTIME_IS_VALID(duration.CMTimeValue)) {
                                               durationInterval = [NSNumber numberWithDouble:CMTimeGetSeconds(duration.CMTimeValue)];
                                           }
                                           return durationInterval;
                                       }];
        
        // TODO: should only check for invalid for the first time
        self.durationIntervalSignal = RACAbleWithStart(self,durationInterval);
        
        

        
        
        [[self.durationSignal filter:^BOOL(NSValue *duration) {
            return CMTIME_IS_VALID(duration.CMTimeValue);
        }] subscribeNext:^(NSValue *duration) {
            @strongify(self);
            NSLog(@"what...?");
            //RACBehaviorSubject *currentTimeSignal =
            if (self.currentTimeSignal) {
                [(RACBehaviorSubject *)self.currentTimeSignal sendNext:[NSValue valueWithCMTime:self.currentTime]];
            }
        }];
        
        
        
        
        CMTime interval = CMTimeMake(1, 1);  // 30fps
        
        //CMTime duration_CMTime = item.duration;
        //NSTimeInterval duration = CMTimeGetSeconds(duration_CMTime);
        
       // [durationSubject sendNext:[NSValue valueWithCMTime:item.duration]];
        
        self.playbackObserver = [self addPeriodicTimeObserverForInterval:interval queue:NULL usingBlock:^(CMTime time) {
            
            @strongify(self);
            
            RACBehaviorSubject *currentTimeSignal = (RACBehaviorSubject *)self.currentTimeSignal;
            // NSTimeInterval duration = CMTimeGetSeconds( item.duration );
            [currentTimeSignal sendNext:[NSValue valueWithCMTime:time]];
            
            
            // NSLog(@"tick %f",CMTimeGetSeconds( time ));
            
            
            //                CMTime endTime = CMTimeConvertScale (player.currentItem.asset.duration, player.currentTime.timescale, kCMTimeRoundingMethod_RoundHalfAwayFromZero);
            //                if (CMTimeCompare(endTime, kCMTimeZero) != 0) {
            //                    double normalizedTime = (double) player.currentTime.value / (double) endTime.value;
            //                    playerScrubber.value = normalizedTime;
            //                }
        }];
    
        
       // [self removeTimeObserver:self.playbackObserver];
    }
    return self;
}


+ (id)playerWithURL:(NSURL *)URL
{
    return [[RPPlayer alloc] initWithURL:URL];
}

- (NSTimeInterval)currentTimeInterval
{
    return CMTimeGetSeconds(self.currentTime);
}
- (void)setCurrentTimeInterval:(NSTimeInterval)currentTimeInterval
{
    _currentTimeInterval = currentTimeInterval;
}

@end
