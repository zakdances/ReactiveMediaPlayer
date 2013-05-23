//
//  rpBigButton.h
//  Danceplanet
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAGradientLayerPlus.h"

@interface rpBigButton : UIButton

@property (nonatomic,weak) CAGradientLayerPlus *layer;
@property (strong) NSString *icon;

+ (rpBigButton *)button:(CGSize)size;

@end
