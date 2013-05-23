//
//  rpBigButton.m
//  Danceplanet
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import "rpBigButton.h"
#import "CocoaPlusMacros.h"

@implementation rpBigButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.layer.needsDisplayOnBoundsChange = YES;
        self.layer.masksToBounds = NO;
        self.clipsToBounds = NO;
        
        self.userInteractionEnabled = YES;
        //self.backgroundColor = RGBA(0xff, 0xff, 0xff, .2);
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Drawing code
    
    CAGradientLayer *layer = self.layer;
    CAGradientLayer *presentationLayer = [layer presentationLayer];
    
    
    if (presentationLayer) {
        
        
    }
    
    
    layer.mask = nil;
    if (!layer.mask) {
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = presentationLayer ? presentationLayer.bounds : layer.bounds;
        maskLayer.fillRule = kCAFillRuleEvenOdd;
        maskLayer.needsDisplayOnBoundsChange = YES;
        maskLayer.masksToBounds = NO;
        
        // Draw path
        //UIBezierPath *path = [self mainCircle:maskLayer];
        //CGFloat layerWidth = layer.bounds.size.width;
        //CGFloat layerHeight = layer.bounds.size.height;
        CGPoint layerCenter = CGPointMake(CGRectGetMidX(layer.bounds),CGRectGetMidY(layer.bounds));
        
        UIBezierPath *path = [UIBezierPath bezierPath];

        
        
        [path addArcWithCenter:layerCenter radius:CGRectGetMidX(layer.bounds) - 7 startAngle:degreesToRadians(0) endAngle:degreesToRadians(360) clockwise:YES];
        [path addArcWithCenter:layerCenter radius:CGRectGetMidX(layer.bounds) - 11 startAngle:degreesToRadians(0) endAngle:degreesToRadians(360) clockwise:YES];
        

        
        
        [path closePath];
        
        

        CGFloat leftMargin = 2;

        [path moveToPoint:CGPointMake(layerCenter.x - 8 + leftMargin, layerCenter.y - 15)];
        [path addLineToPoint:CGPointMake(layerCenter.x + 8 + leftMargin, layerCenter.y)];
        [path addLineToPoint:CGPointMake(layerCenter.x - 8 + leftMargin, layerCenter.y + 15)];
    
        [path closePath];

        maskLayer.path = path.CGPath;
        
        
        
        layer.startPoint = CGPointMake(0.5,0.0);
        layer.endPoint = CGPointMake(0.5,1.0);
        
        NSMutableArray *colors = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            [colors addObject:(id)[UIColor colorWithHue:(0.1 * i) saturation:1 brightness:.8 alpha:1].CGColor];
        }
        layer.colors = @[(id)[UIColor cyanColor].CGColor,(id)[UIColor whiteColor].CGColor];
        
        
        
        maskLayer.shadowOffset = CGSizeMake(0, 0);
        maskLayer.shadowRadius = 5;
        maskLayer.shadowOpacity = 1;
        maskLayer.shadowColor = RGBA(0x00,0x00,0x00, 1).CGColor;
        [layer setMask:maskLayer];
        
    }
}


+ (rpBigButton *)button:(CGSize)size
{
    rpBigButton *button = [rpBigButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(button.bounds.origin.x, button.bounds.origin.y, size.width, size.height);
    return button;
}

+ (Class)layerClass
{
    return [CAGradientLayerPlus class];
}

@end
