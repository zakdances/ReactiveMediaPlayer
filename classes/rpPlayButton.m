//
//  rpPlayButton.m
//  Danceplanet
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import "rpPlayButton.h"
#import "CocoaPlusMacros.h"

@implementation rpPlayButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CAGradientLayerPlus *presentationLayer = [self.layer presentationLayer];
    CAShapeLayerPlus *maskLayer = self.layer.mask ? : [CAShapeLayerPlus layer];

    if (!self.layer.mask) {
        maskLayer.frame = presentationLayer ? presentationLayer.bounds : self.layer.bounds;
        maskLayer.fillRule = kCAFillRuleEvenOdd;
        maskLayer.needsDisplayOnBoundsChange = YES;
        maskLayer.masksToBounds = NO;
    };
    
    
    CGPoint layerCenter = CGPointMake(CGRectGetMidX(maskLayer.bounds),CGRectGetMidY(maskLayer.bounds));
    
    
    maskLayer.pathUI = maskLayer.pathUI ? : [UIBezierPath bezierPath];
    UIBezierPath *path = maskLayer.pathUI;
    [path removeAllPoints];
    
    if (self.icon == RPControlsPlayButtonIconPlay) {
        CGFloat leftMargin = 2;
        
        [path moveToPoint:CGPointMake(layerCenter.x - 8 + leftMargin, layerCenter.y - 15)];
        [path addLineToPoint:CGPointMake(layerCenter.x + 8 + leftMargin, layerCenter.y)];
        [path addLineToPoint:CGPointMake(layerCenter.x - 8 + leftMargin, layerCenter.y + 15)];
        [path closePath];
    }
    else if (self.icon == RPControlsPlayButtonIconPause) {
        
        CGFloat leftMargin = 0;
        
        for (int i = 0; i < 2; i++) {
            if (i == 1) {
                leftMargin = leftMargin + 20;
            }
            [path moveToPoint:CGPointMake(layerCenter.x - 12 + leftMargin, layerCenter.y - 15)];
            [path addLineToPoint:CGPointMake(layerCenter.x - 3 + leftMargin, layerCenter.y - 15)];
            [path addLineToPoint:CGPointMake(layerCenter.x - 3 + leftMargin, layerCenter.y + 15)];
            [path addLineToPoint:CGPointMake(layerCenter.x - 12 + leftMargin, layerCenter.y + 15)];
            [path closePath];
        };
        
    }
    
    
    
    
    
 
    maskLayer.path = maskLayer.pathUI.CGPath;
    self.layer.startPoint = CGPointMake(0.5,0.0);
    self.layer.endPoint = CGPointMake(0.5,1.0);
    
    NSMutableArray *colors = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        [colors addObject:(id)[UIColor colorWithHue:(0.1 * i) saturation:1 brightness:.8 alpha:1].CGColor];
    }
    self.layer.colors = @[(id)[UIColor cyanColor].CGColor,(id)[UIColor whiteColor].CGColor];
    
    
    
    maskLayer.shadowOffset = CGSizeMake(0, 0);
    maskLayer.shadowRadius = 5;
    maskLayer.shadowOpacity = 1;
    maskLayer.shadowColor = RGBA(0x00,0x00,0x00, 1).CGColor;
    [self.layer setMask:maskLayer];
    
}

- (RPControlsPlayButtonIcon)icon
{
    return _icon;
}
- (void)setIcon:(RPControlsPlayButtonIcon)icon
{
    _icon = icon;
    [self.layer setNeedsDisplay];
}
@end
