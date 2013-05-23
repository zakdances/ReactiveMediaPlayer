//
//  rpControls.m
//  Danceplanet
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import "rpControls.h"
#import "CocoaPlusMacros.h"

@implementation rpControls

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = RGBA(0xff, 0xff, 0xff, .4).CGColor;
        self.layer.cornerRadius = 10;
        //self.backgroundColor = [UIColor purpleColor];
        
        UIViewPlus *topRow = [[UIViewPlus alloc] init];
        RAC(topRow,rcl_bounds) = [RACSignal rectsWithSize:[RACSignal sizesWithWidth:self.rcl_boundsSignal.width height:[RACSignal return:@50]]];
        RAC(topRow,rcl_alignmentRect) = [[topRow.rcl_boundsSignal alignTop:self.rcl_boundsSignal.top] alignLeft:self.rcl_boundsSignal.left];
        topRow.backgroundColor = RGBA(0x00, 0x00, 0x00, .2);
        //topRow.backgroundColor = [UIColor cyanColor];
        

        UIViewPlus *leftBox = [[UIViewPlus alloc] init];
        rpPlayButton *button = [rpPlayButton buttonWithType:UIButtonTypeCustom];
        UIViewPlus *rightBox = [[UIViewPlus alloc] init];
        NSArray *topRowItems = @[leftBox,button,rightBox];
        for (UIView *view in topRowItems) {
            [topRow addSubview:view];
        }
        
        
        for (NSInteger i = 0; i < topRowItems.count; i++) {
            
            UIView *item = topRowItems[i];
            
            
            if (i == 0) {
           
            }
            else if (i == 1) {
                self.playButton = (rpPlayButton *)item;
                //RAC(self,playButton.rcl_bounds) = [[self.playButton.rcl_boundsSignal replaceWidth:[RACSignal return:@80]] replaceHeight:topRow.rcl_boundsSignal.height];
                RAC(self,playButton.rcl_bounds) = [RACSignal rectsWithSize:[RACSignal sizesWithWidth:[RACSignal return:@80] height:topRow.rcl_boundsSignal.height]];
                RAC(self,playButton.rcl_alignmentRect) = [[self.playButton.rcl_boundsSignal alignCenterX:topRow.rcl_boundsSignal.centerX] alignTop:topRow.rcl_boundsSignal.top];

                
            }
            else if (i == 2) {
                
            }
            
            
            
        };
        
        
        
        
        
        
  

//        rpSlider *volumeSlider = [[rpSlider alloc] init];
//        self.volumeSlider = volumeSlider;
//        self.volumeSlider.maximumValue = 100;
//        self.volumeSlider.backgroundColor = RGBA(0x00, 0x00, 0x00, .7);
//        
//        CGFloat volumeSliderHeight = 32;
//        RAC(self.volumeSlider,rcl_bounds) = [[RACSignal zeroRect] replaceSize:[RACSignal sizesWithWidth:RACAbleWithStart(volumeSliderWidth) height:[RACSignal return:[NSNumber numberWithFloat:volumeSliderHeight]]]];
//        RAC(self.volumeSlider,rcl_alignmentRect) = [[self.volumeSlider.rcl_alignmentRectSignal alignCenterX:self.rcl_boundsSignal.centerX] alignTop:topRow.rcl_frameSignal.bottom];
        UIView *bottomRow = [[UIView alloc] init];
        RAC(bottomRow,rcl_bounds) = [RACSignal rectsWithSize:[RACSignal sizesWithWidth:self.rcl_boundsSignal.width height:[RACSignal return:@32]]];
        RAC(bottomRow,rcl_alignmentRect) = [[bottomRow.rcl_boundsSignal alignLeft:self.rcl_boundsSignal.left] alignTop:topRow.rcl_alignmentRectSignal.bottom];
        //bottomRow.backgroundColor = [UIColor blueColor];
        
        MPVolumeViewPlus *volumeSlider = [[MPVolumeViewPlus alloc] initWithFrame:CGRectMake(0, 0, 200, 32)];
        self.volumeSlider = volumeSlider;
        self.volumeSlider.showsRouteButton = YES;
        self.volumeSlider.showsVolumeSlider = YES;

        //CGFloat volumeSliderHeight = 32;
//        RAC(self.volumeSlider,rcl_bounds) = [[RACSignal zeroRect] replaceSize:[RACSignal sizesWithWidth:RACAbleWithStart(volumeSliderWidth) height:[RACSignal return:[NSNumber numberWithFloat:volumeSliderHeight]]]];
//        RAC(self,volumeSlider.rcl_alignmentRect) = [[self.volumeSlider.rcl_boundsSignal alignCenterX:self.rcl_boundsSignal.centerX] alignTop:topRow.rcl_alignmentRectSignal.bottom];
//        RAC(myVolumeSlider,rcl_bounds) = [[RACSignal zeroRect] replaceSize:[RACSignal sizesWithWidth:RACAbleWithStart(volumeSliderWidth) height:[RACSignal return:[NSNumber numberWithFloat:volumeSliderHeight]]]];
       

        
        
        [bottomRow addSubview:volumeSlider];
        
        NSArray *subviews = @[topRow,bottomRow];
        for (UIView *view in subviews) {
            [self addSubview:view];
        }
        
//        [self.rcl_boundsSignal subscribeNext:^(id x) {
//            NSLog(@"controls bounds %@",x);
//        }];
//        [topRow.rcl_alignmentRectSignal subscribeNext:^(id x) {
//            NSLog(@"topRow rect %@",x);
//        }];
//        [bottomRow.rcl_alignmentRectSignal subscribeNext:^(id x) {
//            NSLog(@"bottomRow rect %@",x);
//        }];
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

+ (rpControls *)controlsWithFrame:(CGRect)frame
{
    rpControls *controls = [[rpControls alloc] initWithFrame:frame];
    return controls;
}
@end
