//
//  dpVideoPlayer.h
//  Danceplanet
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "RPPlayer.h"
#import "rpBigButton.h"
#import "rpSeekControls.h"
#import "rpControls.h"
#import "RACSignal+TimeFormatting.h"

typedef enum {
    ReactiveVideoPause,
    ReactiveVideoSetPlay,
    ReactiveVideoPlay,
    ReactiveVideoSeeking
} ReactiveVideoMode;

@interface dpVideoPlayer : UIView {
    
    __strong RPPlayer *_player;
    __strong RACSignal *_playerSignal;
    //__strong RACBehaviorSubject *_transformedBoundsSignal;
    
    
    
    
    //__strong RACBehaviorSubject *_currentTimeSubject;
    //__strong RACBehaviorSubject *_durationSubject;
    

    
//    __strong RACSignal *_currentTimeInterval_Signal;
//    __strong RACSignal *_durationInterval_Signal;
    
//    __strong NSString *_currentTimeMinuteString;
//    __strong NSString *_durationMinuteString;
//    __strong RACSignal *_currentTimeMinuteStringSignal;
//    __strong RACSignal *_durationMinuteStringSignal;
}

@property (strong) RPPlayer *player;
@property (strong) RACSignal *playerSignal;
@property CGSize maxSize;


@property (nonatomic,weak) AVPlayerLayer *layer;
@property (weak) CALayer *playerLayerContentLayer;

@property (weak) rpSeekControls *seekControls;
@property (weak) rpControls *controls;
@property (weak) rpBigButton *bigBtn;


//@property AVPlayerStatus status;
@property ReactiveVideoMode mode;
@property (strong) RACSignal *modeSignal;
@property (strong) RACSignal *videoScaledSizeSignal;

//@property (strong) NSString *yum;
+ (dpVideoPlayer *)videoPlayer;
+ (dpVideoPlayer *)videoPlayerWithFrame:(CGRect)frame;

- (void)play;

@end
