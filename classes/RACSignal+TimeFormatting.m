//
//  RACSignal+TimeFormatting.m
//  Danceplanet
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import "RACSignal+TimeFormatting.h"
//#import <CoreMedia/CoreMedia.h>
#import "EXTScope.h"

typedef enum {
    RACReadableTimeIncrementHours,
    RACReadableTimeIncrementMinutes,
    RACReadableTimeIncrementSeconds
} RACReadableTimeIncrement;

@implementation RACSignal (TimeFormatting)

- (RACSignal *)_readableTime:(RACReadableTimeIncrement)increment
{
    @weakify(self);
    return [[self map:^id(id value) {
        @strongify(self);
        
        BOOL isTimeInterval = [value isKindOfClass:NSNumber.class];
        BOOL isCMTime = ( !isTimeInterval && [value isKindOfClass:NSValue.class]);
        NSAssert(isTimeInterval || isCMTime, @"Value sent by %@ is not a CMTime, NSTimeInterval, or double: %@",self,value);
        

        NSTimeInterval unformattedTime = 0;
        id returnThing = value;

        if (isTimeInterval) {
            unformattedTime = ((NSNumber *)value).doubleValue;
            returnThing = [NSNumber numberWithInteger:[self stringFormat:unformattedTime increment:increment]];
        }
        else if (isCMTime) {
            CMTime myCMTime = ((NSValue *)value).CMTimeValue;
            if (CMTIME_IS_VALID(myCMTime)) {
                returnThing = [NSNumber numberWithInteger:[self stringFormat:CMTimeGetSeconds(myCMTime) increment:increment]];
            }
            else {
                NSLog(@"uh oh...NOT GOOD!!! %@",value);
                returnThing = @-1;
            }
            //returnThing = CMTIME_IS_VALID(myCMTime) ? [NSNumber numberWithInteger:[self stringFormat:CMTimeGetSeconds(myCMTime) increment:increment]] : value;
 
        }
        

        return returnThing;
    }] filter:^BOOL(id value) {
        // Was an invalid CMTime pass to me? If so, I shouldn't fire.
       // return !( [value isKindOfClass:NSValue.class] && CMTIME_IS_INVALID(((NSValue *)value).CMTimeValue) );
        return YES;
    }];
}

- (RACSignal *)readableHours_roundedDown
{
    return [self _readableTime:RACReadableTimeIncrementHours];
}

- (RACSignal *)readableMinutes_roundedDown
{
    return [self _readableTime:RACReadableTimeIncrementMinutes];
}

- (RACSignal *)readableSeconds_roundedDown
{
    return [self _readableTime:RACReadableTimeIncrementSeconds];
}

//- (NSInteger)stringFormat_from_CMTime:(CMTime)time increment:(RACReadableTimeIncrement)increment
//{
//    return [self stringFormat:CMTimeGetSeconds(time) increment:increment];
//}
- (NSInteger)stringFormat:(NSTimeInterval)time increment:(RACReadableTimeIncrement)increment
{
    
//    NSInteger dTotalSeconds = time;
//  
//    NSLog(@"duration: %lu",(unsigned long)dTotalSeconds);
//
//    
//    NSInteger dHours = floor(dTotalSeconds / 3600);
//    NSInteger dMinutes = floor(dTotalSeconds % 3600 / 60);
//    NSInteger dSeconds = floor(dTotalSeconds % 3600 % 60);
//    
//    NSString *videoDurationText = [NSString stringWithFormat:@"%i:%02i:%02i",dHours, dMinutes, dSeconds];
//    
//    return  videoDurationText;
    NSInteger readableTime = 0;
    
    switch (increment) {
        case RACReadableTimeIncrementHours:
            readableTime = [self readableHours:time];
            break;
        case RACReadableTimeIncrementMinutes:
            readableTime = [self readableMinutes:time];
            break;
        case RACReadableTimeIncrementSeconds:
            readableTime = [self readableSeconds:time];
            break;
//        default:
//            break;
    }
    
//    if (increment == RACReadableTimeIncrementHours) {
//        readableTime = [self readableHours:time];
//    } else if (increment == RACReadableTimeIncrementMinutes) {
//        readableTime = [self readableMinutes:time];
//    } else if (increment == RACReadableTimeIncrementSeconds) {
//        readableTime = [self readableSeconds:time];
//    }
    
    return readableTime;
}


- (NSInteger)readableHours:(NSTimeInterval)time
{
    NSInteger dTotalSeconds = time;
    NSInteger dHours = floor(dTotalSeconds / 3600);
    
    return dHours;
}

- (NSInteger)readableMinutes:(NSTimeInterval)time
{
    NSInteger dTotalSeconds = time;
    NSInteger dMinutes = floor(dTotalSeconds % 3600 / 60);
    
    return dMinutes;
}

- (NSInteger)readableSeconds:(NSTimeInterval)time
{
    NSInteger dTotalSeconds = time;
    NSInteger dSeconds = floor(dTotalSeconds % 3600 % 60);
    
    return dSeconds;
}
@end
