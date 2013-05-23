//
//  dpVideoPlayer.m
//  Danceplanet
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//


#import "dpVideoPlayer.h"
#import "EXTScope.h"

@implementation dpVideoPlayer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        @weakify(self);
        
        self.modeSignal = [RACAbleWithStart(self,mode) distinctUntilChanged];


        // Transform bounds of video layer
        self.videoScaledSizeSignal = [[RACSignal combineLatest:@[
                                        [RACAbleWithStart(self,player.currentItem.tracks) distinctUntilChanged] ,
                                        [RACAbleWithStart(self.maxSize) distinctUntilChanged]]
                                        reduce:^(NSArray *array,NSValue *maxSize){
                                            
                                            
                                            CGSize videoScaledSize = CGSizeZero;
                                            if (CGSizeEqualToSize(maxSize.med_sizeValue, CGSizeZero)) {
                                                return MEDBox(videoScaledSize);
                                            }
                        
                                            for (AVPlayerItemTrack *itemTrack in array) {
                                                if ([itemTrack.assetTrack.mediaType isEqualToString:AVMediaTypeVideo]) {
                                                    
                                                    CGSize naturalSize = itemTrack.assetTrack.naturalSize;
                                                    videoScaledSize = AVMakeRectWithAspectRatioInsideRect(naturalSize, CGRectWithSize(maxSize.med_sizeValue)).size;
                                                
                                                }
                                                
                                            }
                                            
                                            //CGRect newRect = CGRectWithSize(itemTrack.assetTrack.naturalSize);
                                            //NSLog(@"vid scaled size: %@",MEDBox(videoScaledSize));
                                            return MEDBox(videoScaledSize);
                                        }] filter:^BOOL(NSValue *videoScaledSize) {
                                            return !CGSizeEqualToSize(videoScaledSize.med_sizeValue, CGSizeZero);
                                        }];
        
//        self.transformedBoundsSignal = [[[[[RACAbleWithStart(self,playerLayerContentLayer.sublayerTransform) distinctUntilChanged]
//                filter:^BOOL(NSValue *sublayerTransform) {
//                    return !CATransform3DIsIdentity(sublayerTransform.CATransform3DValue);
//                }]
//                map:^id(NSValue *sublayerTransform) {
//                    @strongify(self);
//                    
//                    CGRect transformBounds = CGRectApplyAffineTransform(self.playerLayerContentLayer.bounds, CATransform3DGetAffineTransform(sublayerTransform.CATransform3DValue));
//
//                    return MEDBox(transformBounds);
//        }] distinctUntilChanged] take:2];
//        self.transformedBoundsSignal = [[[[RACSignal combineLatest:
//          @[[RACAbleWithStart(self.playerLayerContentLayer) distinctUntilChanged] ,
//          self.playerSignal ,
//          [self.rcl_boundsSignal distinctUntilChanged]]
//                           reduce:^(CALayer *playerLayerContentLayer,AVPlayer *player,NSValue *selfBounds) {
//                           
//           RACSignal *signal = [RACSignal empty];
//           if ( !CGRectIsEmpty(selfBounds.med_rectValue) && player && playerLayerContentLayer ) {
//               
//               
//               //@weakify(playerLayerContentLayer);
//               //@weakify(selfBounds);
//               NSLog(@"seeing this?");
//               //self.layer.bounds = selfBounds.med_rectValue;
//               signal = [[RACSignal combineLatest:@[[RACAbleWithStart(playerLayerContentLayer.sublayerTransform) distinctUntilChanged]]
//                                           reduce:^(NSValue *sublayerTransform){
//                                       //@strongify(playerLayerContentLayer);
//                                       //@strongify(selfBounds);
//                                       RACSignal *subSignal = [RACSignal empty];
//                                       if (!CATransform3DIsIdentity(sublayerTransform.CATransform3DValue)) {
//                                           
//                                           CGRect transformBounds = CGRectApplyAffineTransform(playerLayerContentLayer.bounds, CATransform3DGetAffineTransform(sublayerTransform.CATransform3DValue));
//                                           
//                                           NSLog(@"vid %@",NSStringFromCGSize(transformBounds.size));
//                                           NSLog(@"vid t %@",NSStringFromCGAffineTransform(CATransform3DGetAffineTransform(sublayerTransform.CATransform3DValue)));
//                                           if ( ABS(CGRectGetWidth(transformBounds) - CGRectGetWidth(selfBounds.med_rectValue) ) < 1 ||
//                                                ABS(CGRectGetHeight(transformBounds) - CGRectGetHeight(selfBounds.med_rectValue)) < 1) {
//                                               
//                                               subSignal = [RACSignal return:MEDBox(transformBounds)];
//                                           }
//                                       }
//                                       else {
//                                           NSLog(@"empty!!!");
//                                       }
//                                       return subSignal;
//                                   }] switchToLatest];
//           }
//           
//           return signal;
//       }] switchToLatest] distinctUntilChanged] take:2];
//        self.currentTime = CMTimeMakeWithSeconds(0, 1);
//        self.duration = CMTimeMakeWithSeconds(0, 1);
//        [self.rcl_boundsSignal subscribeNext:^(NSValue *x) {
//           NSLog(@"mine %@",NSStringFromCGSize(x.med_rectValue.size));
//        }];
//        [[RACAbleWithStart(self.playerLayerContentLayer) distinctUntilChanged] subscribeNext:^(id x) {
//            NSLog(@"player layer changed %@",x);
//        }];
        
        

        //CGFloat controlsWidth = 300;
        //CGFloat slidersWidth = controlsWidth - 80;
        RACSignal *controlsWidth = [self.rcl_boundsSignal.width minus:[RACSignal return:@30]];
        RACSignal *slidersWidth = [controlsWidth minus:[RACSignal return:@80]];

        
        rpSeekControls *seekControls = [[rpSeekControls alloc] init];
        self.seekControls = seekControls;
        RAC(self,seekControls.seekBarWidth) = slidersWidth;
        
        
        
        // rcl_bounds testing
        RACSignal *boundsSignal = [[RACSignal zeroRect] replaceSize:[RACSignal sizesWithWidth:controlsWidth height:[RACSignal return:@40]]];
        RAC(self.seekControls,rcl_bounds) = boundsSignal;
        //RAC(self.seekControls,rcl_frame) = [[self.seekControls.rcl_boundsSignal alignCenterX:self.rcl_boundsSignal.centerX] replaceY:[RACSignal return:@10]];
        RAC(self.seekControls,rcl_alignmentRect) = [[boundsSignal alignCenterX:self.rcl_boundsSignal.centerX] alignTop:[self.rcl_boundsSignal.top plus:[RACSignal return:@10]]];
        
        
        
        rpControls *controls = [rpControls controlsWithFrame:CGRectZero];
        self.controls = controls;

        

        RAC(self,controls.intrinsicContentSize) = [[RACAbleWithStart(self,controls.layer.sublayers) map:^id(NSArray *array) {
        
            NSMutableArray *rectBottoms = [NSMutableArray array];
            NSMutableArray *rectRights = [NSMutableArray array];
            for (CALayer *layer in array) {
                
                if (layer.delegate && [layer.delegate isKindOfClass:UIView.class]) {
                    UIView *view = layer.delegate;
                    [rectBottoms addObject:view.rcl_alignmentRectSignal.bottom];
                    [rectRights addObject:view.rcl_alignmentRectSignal.right];
                }
                
            }
             
            RACSignal *signal = [RACSignal zeroSize];
            if (rectBottoms.count > 0) {
                signal = [RACSignal sizesWithWidth:[RACSignal max:rectRights] height:[RACSignal max:rectBottoms]];
            }
            return signal;
        }] switchToLatest];
       
//        [self.controls.rcl_intrinsicContentSizeSignal subscribeNext:^(id x) {
//            NSLog(@"size: %@",x);
//        }];
//        [RACAbleWithStart(self,controls.intrinsicContentSize) subscribeNext:^(id x) {
//            NSLog(@"intr %@",x);
//        }];
       
        
       // self.controls.volumeSliderWidth = slidersWidth;
        //controls.backgroundColor = [UIColor orangeColor];
        RAC(self,controls.rcl_bounds) = [RACSignal rectsWithSize:[RACSignal sizesWithWidth:controlsWidth height:self.controls.rcl_intrinsicContentSizeSignal.height]];
        RAC(self,controls.rcl_alignmentRect) = [[self.controls.rcl_boundsSignal alignCenterX:self.rcl_boundsSignal.centerX] alignBottom:[self.rcl_boundsSignal.bottom minus:[RACSignal return:@20]]];
        
        
        
        // Set button action
        [self rac_liftSelector:@selector(_toggle:) withObjects:[self.controls.playButton rac_signalForControlEvents:UIControlEventTouchUpInside]];
        
        [[RACSignal combineLatest:@[RACAbleWithStart(self,controls.playButton),self.seekControls.seekBar.touchStatusSignal,RACAbleWithStart(mode)]]
         subscribeNext:^(RACTuple *tuple) {
             RACTupleUnpack(rpPlayButton *playButton,NSNumber *seekBarStatus,NSNumber *mode) = tuple;
             if (seekBarStatus.integerValue == SeekBarTouchStatusNoTouch) {
                 if (mode.integerValue == ReactiveVideoPlay) {
                     [playButton setTitle:@"pause" forState:UIControlStateNormal];
                     playButton.icon = RPControlsPlayButtonIconPause;
                 }
                 else {
                     [playButton setTitle:@"play" forState:UIControlStateNormal];
                     playButton.icon = RPControlsPlayButtonIconPlay;
                 }
             }
             
             
           
         }];
    
        
        
        
        

        
        
        
        
        [self addSubview:controls];
        
        
        
      
      
        rpBigButton *bigButton = [rpBigButton button:CGSizeMake(100, 100)];
        self.bigBtn = bigButton;
        [self addSubview:self.bigBtn];
        
        

        

        RACSignal *bigBtnSignal = [self.bigBtn rac_signalForControlEvents:UIControlEventTouchUpInside];
        [self rac_liftSelector:@selector(_play:) withObjects:bigBtnSignal];
        
     
        // Position button
        RAC(self.bigBtn,rcl_frame) = [[RACSignal return:MEDBox(self.bigBtn.frame)] alignCenter:[RACSignal pointsWithX:self.rcl_boundsSignal.centerX Y:self.rcl_boundsSignal.centerY]];


        
        RAC(self.bigBtn,alpha) = [RACSignal combineLatest:@[
                                  self.modeSignal,
                                  RACAbleWithStart(self,layer.readyForDisplay),
                                  self.playerSignal,
                                  RACAbleWithStart(self,controls.alpha),
                                  RACAbleWithStart(self,controls.hidden)]
            reduce:^(NSNumber *mode,NSNumber *readyForDisplay,AVPlayer *player,NSNumber *controlsAlpha,NSNumber *controlsHidden){
                   NSNumber *alpha = @0;
                   if (mode.integerValue == ReactiveVideoPlay &&
                       readyForDisplay.boolValue == YES &&
                       player &&
                       ( controlsAlpha.floatValue <= 0 ||
                       controlsHidden.boolValue == YES )) {
                       alpha = @1;
                   }
                   return  alpha;
        }];
        
        
        
        

        
        
        
        CALayer *playerLayerContentLayer = (CALayer *)[[self.layer sublayers] objectAtIndex:0];
        self.playerLayerContentLayer = playerLayerContentLayer;

        
        
        

        
        
        
        
        RACSignal *seekBarSignal = [RACAbleWithStart(self.seekControls,seekBar) distinctUntilChanged];

        
        
//                
//                CMTime interval = CMTimeMake(1, 1);  // 30fps
//
//                //CMTime duration_CMTime = item.duration;
//                //NSTimeInterval duration = CMTimeGetSeconds(duration_CMTime);
//                [durationSubject sendNext:[NSValue valueWithCMTime:item.duration]];
//                
//                self.playbackObserver = [player addPeriodicTimeObserverForInterval:interval queue:NULL usingBlock:^(CMTime time) {

//                    
//                    //                CMTime endTime = CMTimeConvertScale (player.currentItem.asset.duration, player.currentTime.timescale, kCMTimeRoundingMethod_RoundHalfAwayFromZero);
//                    //                if (CMTimeCompare(endTime, kCMTimeZero) != 0) {
//                    //                    double normalizedTime = (double) player.currentTime.value / (double) endTime.value;
//                    //                    playerScrubber.value = normalizedTime;
//                    //                }
//                }];
//    
//            } completed:^{
//                [player removeTimeObserver:self.playbackObserver];
//            }];

        

        [RACAbleWithStart(self,seekControls.seekBar.maximumValue) subscribeNext:^(id x) {
            NSLog(@"max val %@",x);
        }];

        
        // Set duration on seek controls
        // TODO: self.contols and self.controls.seekBar needs to be checked for null
        RAC(self,seekControls.seekBar.maximumValue) = [[self.playerSignal map:^id(RPPlayer *player) {
            RACSignal *signal = [RACSignal return:@0];
            if (player) {
                signal = player.durationIntervalSignal;
            }
            
            return signal;
        }] switchToLatest];
        
        
        
        RACSignal *shouldSeekBarBeActive = [[self.playerSignal map:^id(RPPlayer *player) {
            RACSignal *signal = [RACSignal return:@NO];
            if (player) {
                signal = [player.durationIntervalSignal map:^id(NSNumber *durationInterval) {
                    return [NSNumber numberWithBool:(durationInterval.doubleValue > 0)];
                }];
            }
            
            return signal;
        }] switchToLatest];
        RAC(self,seekControls.seekBar.alpha) = [RACSignal if:shouldSeekBarBeActive then:[RACSignal return:@1] else:[RACSignal return:@.6]];
        RAC(self,seekControls.seekBar.userInteractionEnabled) = shouldSeekBarBeActive;
//        RAC(self,seekControls.seekBar.alpha) = [[self.playerSignal map:^id(RPPlayer *player) {
//            NSNumber *dimmedAlphaValue = @.6;
//            RACSignal *signal = [RACSignal return:dimmedAlphaValue];
//            if (player) {
//                signal = [RACSignal if:[player.durationIntervalSignal map:^id(NSNumber *durationInterval) {
//                    return [NSNumber numberWithBool:(durationInterval.doubleValue > 0)];
//                }] then:[RACSignal return:@1] else:[RACSignal return:dimmedAlphaValue]];
//            }
//            
//            return signal;
//        }] switchToLatest];
        
        
//        RAC(self,seekControls.seekBar.maximumValue) = [[self.playerSignal
//                let:^RACSignal *(RACSignal *sharedSignal) {
//
//                    NSLog(@"hi %@",sharedSignal.first);
//                    return [RACSignal return:@120];
//        }] distinctUntilChanged];
        
        
        
        
        // time current time text
        RAC(self.seekControls.currentTimeLabel,text) = [[self.playerSignal map:^id(RPPlayer *player) {
            
            RACSignal *signal;
            if (player) {
                signal = [RACSignal combineLatest:@[
                          player.currentTimeSignal.readableMinutes_roundedDown ,
                          player.currentTimeSignal.readableSeconds_roundedDown]
                       reduce:^(NSNumber *minutes,NSNumber *seconds){
                           NSString *text = [NSString stringWithFormat:@"%@:%02d",minutes,seconds.integerValue];
                           return text;
                }];
            }
            else {
                signal = [RACSignal return:@"0:00"];
            }

            return signal;
        }] switchToLatest];
        

        // time duration text
        RAC(self,seekControls.durationLabel.text) = [[self.playerSignal map:^id(RPPlayer *player) {
            RACSignal *signal = [RACSignal return:@"0:00"];
            if (player) {
                NSLog(@"ok...");
                signal = [RACSignal combineLatest:@[
                          player.durationSignal.readableMinutes_roundedDown ,
                          player.durationSignal.readableSeconds_roundedDown]
                                           reduce:^(NSNumber *minutes,NSNumber *seconds){
                                               NSLog(@"dur min text: %@",minutes);
                                               NSString *text = [NSString stringWithFormat:@"%@:%02d",minutes,seconds.integerValue];
                                               return text;
                                           }];
//                [player.durationSignal.readableMinutes_roundedDown subscribeNext:^(id x) {
//                    NSLog(@"made it! %@",x);
//                }];
            }
            
            return signal;
        }] switchToLatest];
       // RAC(self.seekControls.durationLabel) = [RACSignal return:@"0:00"];
        
//        [[[RACAbleWithStart(self,player.durationSignal.readableMinutes_roundedDown) map:^id(RACSignal *signal) {
//            if (!signal) {
//                signal = [RACSignal empty];
//            }
//            return signal;
//        }] switchToLatest] subscribeNext:^(NSNumber *myCMTime) {
//            NSLog(@"from dur sig: %@",myCMTime);
//        }];
        
//        [[[RACAbleWithStart(self,player.currentTimeSignal.readableSeconds_roundedDown) map:^id(RACSignal *signal) {
//            if (!signal) {
//                signal = [RACSignal empty];
//            }
//            return signal;
//        }] switchToLatest] subscribeNext:^(NSNumber *myCMTime) {
//            NSLog(@"from cur sig: %@",myCMTime);
//        }];
//        RAC(self.seekControls.durationLabel,text) = [RACSignal if:[self.playerSignal map:^id(id value) {
//            return (value) ? @YES : @NO;
//        }] then:[RACSignal combineLatest:@[
//                 self.player.durationSignal.readableMinutes_roundedDown ,
//                 self.player.durationSignal.readableSeconds_roundedDown]
//                                  reduce:^(NSNumber *minutes,NSNumber *seconds){
//                                      NSString *text = [NSString stringWithFormat:@"%@:%02d",minutes,seconds.integerValue];
//                                      return text;
//        }] else:[RACSignal return:@"0:00"]];
        
//        RAC(self.seekControls.durationLabel,text) = [RACSignal combineLatest:@[self.durationSignal.readableMinutes_roundedDown ,
//                                                     self.durationSignal.readableSeconds_roundedDown]
//                reduce:^(NSNumber *minutes,NSNumber *seconds){
//                    NSString *text = [NSString stringWithFormat:@"%@:%02d",minutes,seconds.integerValue];
//                    return text;
//        }];
        

        

        
        // adjust video while seekBar is being dragged
        RACSignal *seekBarTouchStatus = [self.seekControls.seekBar.touchStatusSignal distinctUntilChanged];
        
        [[[[RACSignal combineLatest:@[RACAbleWithStart(self.seekControls),seekBarTouchStatus]
                             reduce:^(rpSeekControls *seekControls,NSNumber *touchStatusNum){
                                 
              @strongify(self);
              SeekBarTouchStatus touchStatus = touchStatusNum.integerValue;
              RACSignal *newSignal;
            
    
              if (touchStatus == SeekBarTouchStatusDragging) {
                  
//                  // TODO: fix this whole damn thing. Should use a more natural flow.

                  // Get mode before dragging
                  NSInteger mode = self.mode;
                
                  newSignal = [[[[RACSignal combineLatest:@[
                                  
                                  [seekControls.seekBar.valueSignal distinctUntilChanged] ,
                                  [seekControls.seekBar.touchStatusSignal distinctUntilChanged]
                                  
                                ]]
                                takeWhileBlock:^BOOL(RACTuple *tuple) {
                                    
                                    SeekBarTouchStatus touchStatus = ((NSNumber *)tuple.second).integerValue;
                                    return (touchStatus == SeekBarTouchStatusDragging);
                                    
                                }] deliverOn:[RACScheduler mainThreadScheduler]]
                                 doCompleted:^{
                                    
                                    
                                     if (mode == ReactiveVideoPlay) {
                                         [self play];
                                     }
                                }];
                  
              }
              else if (touchStatus == SeekBarTouchStatusNoTouch) {
                  newSignal = [RACSignal never];
              }
              
              
              return newSignal;
            
              }] switchToLatest] deliverOn:[RACScheduler mainThreadScheduler]]
              subscribeNext:^(RACTuple *tuple) {
                 
                  @strongify(self);
                  [self pause];
                  
                  NSNumber *seekBarValue = tuple.first;
                  CMTime newTime = CMTimeMakeWithSeconds(seekBarValue.floatValue, 1);
                  
                  if (CMTIME_IS_VALID(newTime)) {
                      
                      [self.player seekToTime:newTime completionHandler:^(BOOL finished) {
                          
                      }];
                  }
                  
                  
                  
          }];

        
    
        // Adjust seekBar value
        RACSignal *progressSignal = [[[RACSignal combineLatest:@[self.playerSignal,self.modeSignal]] map:^id(RACTuple *tuple) {
            RACTupleUnpack(RPPlayer *player,NSNumber *mode) = tuple;
            RACSignal *signal = [RACSignal empty];
            if (player && mode.integerValue == ReactiveVideoPlay) {
                signal = player.currentTimeIntervalSignal;
            }
            
            return signal;
        }] switchToLatest];
        [self.seekControls.seekBar rac_liftSelector:@selector(_setValue:animated:) withObjects:progressSignal,[RACSignal return:@NO]];
//        [[[RACSignal combineLatest:@[seekBarSignal ,
//                                     self.currentTimeInterval_Signal ,
//                                     RACAbleWithStart(self.mode)
//                                     ]]
//          filter:^BOOL(RACTuple *tuple) {
//              NSNumber *mode = tuple.third;
//              return (tuple.first && mode.integerValue != ReactiveVideoSeeking) ? YES : NO;
//        }] subscribeNext:^(RACTuple *tuple) {
// 
//            rpSlider *seekBar = tuple.first;
//            NSNumber *videoCurrentTime = tuple.second;
//
//                [seekBar setValue:videoCurrentTime.doubleValue animated:NO];
//
//
//        }];
        
        
        
        
        
        
        
        
        NSArray *subviews = @[self.seekControls];
        for (UIView *view in subviews) {
            [self addSubview:view];
        }
        
        
        
    }
    return self;
}





+ (dpVideoPlayer *)videoPlayer
{
    dpVideoPlayer *videoPlayer = [[dpVideoPlayer alloc] init];
    return videoPlayer;
}
+ (dpVideoPlayer *)videoPlayerWithFrame:(CGRect)frame
{
    dpVideoPlayer *videoPlayer = [[dpVideoPlayer alloc] initWithFrame:frame];
    return videoPlayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//- (void)makeSubviews
//{
//    
//   
//
//}
- (void)_play:(id)x
{
    [self play];
}

- (void)play
{

    if (self.mode != ReactiveVideoPlay) {
        if (self.player) {
            [self.player play];
        }
        self.mode = ReactiveVideoPlay;
    }
}


- (void)pause
{
    if (self.mode != ReactiveVideoPause) {
        if (self.player) {
            [self.player pause];
        }
        self.mode = ReactiveVideoPause;
    }
}

- (void)seeking
{
    if (self.mode != ReactiveVideoSeeking) {
        if (self.player) {
            [self.player pause];
        }
        self.mode = ReactiveVideoSeeking;
    }
}

- (void)_toggle:(id)x
{
    [self toggle];
}
- (void)toggle
{
    if (self.mode == ReactiveVideoPause) {
        [self play];
    }
    else if (self.mode == ReactiveVideoPlay) {
        [self pause];
    }
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.mode == ReactiveVideoPlay) {
        self.mode = ReactiveVideoPause;
    }
}

// Seekbar events
//- (void)blah
//{
//    
//}







+ (Class)layerClass
{
    return [AVPlayerLayer class];
}








//- (NSString *)currentTimeMinuteString
//{
//    if (_currentTimeMinuteString) {
//        
//    }
//}


//- (RACSignal *)currentTimeInterval_Signal
//{
//    if (!_currentTimeInterval_Signal) {
//        _currentTimeInterval_Signal = [RACAbleWithStart(self.currentTimeInterval) distinctUntilChanged];
//    }
//    return _currentTimeInterval_Signal;
//}
//- (void)setCurrentTimeInterval_Signal:(RACSignal *)currentTimeInterval_Signal
//{
//    _currentTimeInterval_Signal = currentTimeInterval_Signal;
//}
//
//- (RACSignal *)durationInterval_Signal
//{
//    if (!_durationInterval_Signal) {
//  
//        _durationInterval_Signal = [RACAbleWithStart(self.durationInterval) distinctUntilChanged];
//    }
//    return _durationInterval_Signal;
//}
//- (void)setDurationInterval_Signal:(RACSignal *)durationInterval_Signal
//{
//    _durationInterval_Signal = durationInterval_Signal;
//}





//- (RACSignal *)currentTimeMinuteStringSignal
//{
//    
//    if (!_currentTimeMinuteStringSignal) {
//        _currentTimeMinuteStringSignal = [RACAbleWithStart(self.currentTimeMinuteString) distinctUntilChanged];
//    }
//    return _currentTimeMinuteStringSignal;
//}
//- (void)setCurrentTimeMinuteStringSignal:(RACSignal *)currentTimeMinuteStringSignal
//{
//    _currentTimeMinuteStringSignal = currentTimeMinuteStringSignal;
//}
//
//- (RACSignal *)durationMinuteStringSignal
//{
//    if (!_durationMinuteStringSignal) {
//        _durationMinuteStringSignal = [RACAbleWithStart(self.durationMinuteString) distinctUntilChanged];
//    }
//    return _durationMinuteStringSignal;
//}
//- (void)setDurationMinuteStringSignal:(RACSignal *)durationMinuteStringSignal
//{
//    _durationMinuteStringSignal = durationMinuteStringSignal;
//}





//- (NSURL *)urlForMedia
//{
//    return _urlForMedia;
//}
//- (void)setUrlForMedia:(NSURL *)urlForMedia
//{
//    NSURL *originalURL = _urlForMedia;
//    _urlForMedia = urlForMedia;
//   // NSLog(@"setting");
//    if (_urlForMedia && ![originalURL isEqual:_urlForMedia]) {
//        
//        self.player = nil;
//        [self player];
//    }
//}

- (RPPlayer *)player
{
    return _player;
}
- (void)setPlayer:(RPPlayer *)player
{
    
    self.layer.player = player;
    self.layer.videoGravity = AVLayerVideoGravityResizeAspect;
    //self.layer.videoGravity = AVLayerVideoGravityResize;
    self.layer.frame = self.bounds;
    _player = player;
}

- (RACSignal *)playerSignal
{
    if (!_playerSignal) {
        _playerSignal = [RACAbleWithStart(self,player) distinctUntilChanged];
    }
    return _playerSignal;
}
- (void)setPlayerSignal:(RACSignal *)playerSignal
{
    _playerSignal = playerSignal;
}
@end
