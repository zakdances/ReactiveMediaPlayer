//
//  rpSeekControls.h
//  Danceplanet
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import "UIViewPlus.h"
#import "rpSlider.h"
#import "CAGradientLayerPlus.h"

@interface rpSeekControls : UIViewPlus

@property (weak) rpSlider *seekBar;
@property CGFloat seekBarWidth;
@property (weak) UILabel *currentTimeLabel;
@property (weak) UILabel *durationLabel;

@end
