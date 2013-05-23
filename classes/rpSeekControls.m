//
//  rpSeekControls.m
//  Danceplanet
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import "rpSeekControls.h"
#import "CocoaPlusMacros.h"

@implementation rpSeekControls

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.clipsToBounds = NO;
        self.layer.masksToBounds = NO;
        
        
        UIViewPlus *bg = [[UIViewPlus alloc] init];
        bg.clipsToBounds = NO;
        bg.layer.masksToBounds = NO;
       // bg.backgroundColor = [UIColor magentaColor];
        bg.backgroundColor = RGBA(0x00, 0x00, 0x00, .5);
        bg.layer.borderColor = RGBA(0xff, 0xff, 0xff, .5).CGColor;
        bg.layer.borderWidth = 1;
        bg.layer.cornerRadius = 10;
        RAC(bg,rcl_bounds) = self.rcl_boundsSignal;
        //RACSignal *bgSizeSignal = [RACSignal sizesWithWidth:bg.rcl_boundsSignal.width height:bg.rcl_boundsSignal.height];
        RAC(bg,rcl_alignmentRect) = [[bg.rcl_boundsSignal alignLeft:self.rcl_boundsSignal.left] alignTop:self.rcl_boundsSignal.top];
        
        CAGradientLayerPlus *mask = [CAGradientLayerPlus layer];
        mask.colors = @[(id)RGBA(0x00, 0x00, 0x00, .2).CGColor,(id)RGBA(0x00, 0x00, 0x00, 1).CGColor];
        mask.needsDisplayOnBoundsChange = YES;
        //bg.layer.mask = mask;

        
        [[[[RACSignal combineLatest:@[RACAbleWithStart(bg,layer),bg.rcl_boundsSignal]] filter:^BOOL(RACTuple *tuple) {
            return (((CAGradientLayerPlus *)tuple.first).mask) ? YES : NO;
        }] deliverOn:[RACScheduler mainThreadScheduler]]
            subscribeNext:^(RACTuple *tuple) {

                RACTupleUnpack(CAGradientLayerPlus *layer,NSValue *superViewBounds) = tuple;
                CAGradientLayerPlus *mask = (CAGradientLayerPlus *)layer.mask;
                mask.bounds = superViewBounds.med_rectValue;
                mask.position = CGPointMake(CGRectGetMidX(superViewBounds.med_rectValue), mask.position.y);
                //[mask setNeedsDisplay];
        }];
        
        
        
        
        
        rpSlider *seekBar = [[rpSlider alloc] init];
        self.seekBar = seekBar;
        
//        RAC(self.seekBar,rcl_bounds) = [RACSignal rectsWithX:[RACSignal return:@0] Y:[RACSignal return:@0] width:self.rcl_boundsSignal.width height:[RACSignal return:@40]];
        CGFloat seekBarHeight = 40;
        RAC(self.seekBar,rcl_bounds) = [[RACSignal zeroRect] replaceSize:[RACSignal sizesWithWidth:RACAbleWithStart(self.seekBarWidth) height:[RACSignal return:[NSNumber numberWithFloat:seekBarHeight]]]];
        
        RAC(self.seekBar,rcl_alignmentRect) = [self.seekBar.rcl_alignmentRectSignal alignCenterX:self.rcl_boundsSignal.centerX];
        
        
        
        
        
        UILabel *currentTimeLabel = [[UILabel alloc] init];
        self.currentTimeLabel = currentTimeLabel;
        UILabel *durationLabel = [[UILabel alloc] init];
        self.durationLabel = durationLabel;
        
        //NSArray *labels = @[timeElapsed,timeDuration];
        for (UILabel *label in @[self.currentTimeLabel,self.durationLabel]) {
            label.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
            label.textColor = RGBA(0x99, 0x99, 0x99, 1);
            label.backgroundColor = [UIColor clearColor];
            label.text = @"0:00";
            [label sizeToFit];
            
            [[RACSignal combineLatest:@[[RACSignal return:label],[RACAbleWithStart(label,text) distinctUntilChanged]]]
                subscribeNext:^(RACTuple *tuple) {
                    UILabel *label = tuple.first;
                    [label sizeToFit];
            }];
        };
        
        
        
//        RACSignal *timeElapsedBox = [[RACSignal rectsWithSize:[RACSignal sizesWithWidth:self.seekBar.rcl_alignmentRectSignal.x height:timeElapsed.rcl_boundsSignal.height]] alignCenterY:self.seekBar.rcl_alignmentRectSignal.centerY];
        RACSignal *timeElapsedBox = [[RACSignal rectsWithSize:[RACSignal sizesWithWidth:self.seekBar.rcl_alignmentRectSignal.left height:self.currentTimeLabel.rcl_boundsSignal.height]] alignCenterY:self.seekBar.rcl_alignmentRectSignal.centerY];
        RAC(self.currentTimeLabel,rcl_alignmentRect) = [[self.currentTimeLabel.rcl_boundsSignal alignCenterX:timeElapsedBox.centerX] alignTop:timeElapsedBox.top];
        
        
        RACSignal *timeDurationBox = [[RACSignal rectsWithX:self.seekBar.rcl_alignmentRectSignal.right Y:[RACSignal zero] width:[self.rcl_boundsSignal.right minus:self.seekBar.rcl_alignmentRectSignal.right] height:durationLabel.rcl_boundsSignal.height] alignCenterY:self.seekBar.rcl_alignmentRectSignal.centerY];
        RAC(self.durationLabel,rcl_alignmentRect) = [[self.durationLabel.rcl_boundsSignal alignCenterX:timeDurationBox.centerX] alignTop:timeDurationBox.top];
        
        
        
        NSArray *subviews = @[bg,self.currentTimeLabel,self.durationLabel,self.seekBar];
        for (UIView *view in subviews) {
            [self addSubview:view];
        }
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
