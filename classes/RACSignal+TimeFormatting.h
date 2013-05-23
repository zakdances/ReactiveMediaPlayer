//
//  RACSignal+TimeFormatting.h
//  Danceplanet
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "RACSignal.h"


@interface RACSignal (TimeFormatting)

- (RACSignal *)readableHours_roundedDown;
- (RACSignal *)readableMinutes_roundedDown;
- (RACSignal *)readableSeconds_roundedDown;

@end
