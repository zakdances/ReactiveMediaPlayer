//
//  rpControls.h
//  Danceplanet
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import "UIViewPlus.h"
#import "rpSlider.h"
#import "rpPlayButton.h"
#import "MPVolumeViewPlus.h"

@interface rpControls : UIViewPlus


@property (weak) rpPlayButton *playButton;

@property (weak) MPVolumeViewPlus *volumeSlider;
//@property CGFloat volumeSliderWidth;

+ (rpControls *)controlsWithFrame:(CGRect)frame;

@end
