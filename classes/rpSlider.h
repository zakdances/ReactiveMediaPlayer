//
//  rpSeekBar.h
//  Danceplanet
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import "TLTiltSlider.h"

typedef enum {
    SeekBarTouchStatusNoTouch,
    SeekBarTouchStatusDragging
} SeekBarTouchStatus;

@interface rpSlider : TLTiltSlider {
    __strong RACBehaviorSubject *_valueSignal;
    __strong RACSignal *_touchStatusSignal;
 //   __strong RACBehaviorSubject *_playingSignal;
//    __strong RACSubject *_seekWithBarSignal;
}

@property SeekBarTouchStatus touchStatus;


@property (strong,readonly) RACSignal *valueSignal;
@property (strong,readonly) RACSignal *touchStatusSignal;
//@property (strong) RACSignal *playingSignal;
//@property (strong) RACSignal *seekWithBarSignal;

@end
