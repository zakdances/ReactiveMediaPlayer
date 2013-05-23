//
//  rpSeekBar.m
//  Danceplanet
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import "rpSlider.h"

@implementation rpSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.continuous = YES;
        
        //NSNumber *value = [NSNumber numberWithFloat:self.value];
        _valueSignal = [RACBehaviorSubject behaviorSubjectWithDefaultValue:[NSNumber numberWithFloat:self.value]];
        //_playingSignal = [RACBehaviorSubject behaviorSubjectWithDefaultValue:value];
    
        _touchStatusSignal = [RACAbleWithStart(self,touchStatus) distinctUntilChanged];
//        RACSubject *seekWithBarSignal = [RACSubject subject];
//        _seekWithBarSignal = seekWithBarSignal;
//        
//        
//        
//        @weakify(seekWithBarSignal);
//        [[[RACSignal combineLatest:@[self.valueSignal,RACAbleWithStart(touchStatus)]]
//            
//         filter:^BOOL(RACTuple *tuple) {
//            NSNumber *touchStatus = tuple.second;
//            return (touchStatus.integerValue == SeekBarTouchStatusDragging);
//        }] subscribeNext:^(RACTuple *tuple) {
//               @strongify(seekWithBarSignal);
//               [seekWithBarSignal sendNext:tuple.first];
//           } completed:^{
//               @strongify(seekWithBarSignal);
//               [seekWithBarSignal sendCompleted];
//               _seekWithBarSignal = nil;
//               NSLog(@"seekBar dragging done!");
//           }];
//       [self.valueSignal subscribeNext:^(id x) {
//           NSLog(@"double trubble %@",x);
//       }];

        //_seekSignal = [RACSubject subject];
        [self addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    CGPoint touchLocation = [[touches anyObject] locationInView:self];
//    if (touchLocation.x < 0 || touchLocation.y<0)return;
//    if (touchLocation.x > self.bounds.size.width || touchLocation.y > self.bounds.size.height)return;
    
    self.touchStatus = SeekBarTouchStatusDragging;
    [super touchesBegan:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    CGPoint touchLocation = [[touches anyObject] locationInView:self];
//    if (touchLocation.x < 0 || touchLocation.y<0)return;
//    if (touchLocation.x > self.bounds.size.width || touchLocation.y > self.bounds.size.height)return;
    
    [super touchesMoved:touches withEvent:event];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    CGPoint touchLocation = [[touches anyObject] locationInView:self];
//    if (touchLocation.x < 0 || touchLocation.y<0)return;
//    if (touchLocation.x > self.bounds.size.width || touchLocation.y > self.bounds.size.height)return;
  
    self.touchStatus = SeekBarTouchStatusNoTouch;
    [super touchesEnded:touches withEvent:event];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    CGPoint touchLocation = [[touches anyObject] locationInView:self];
//    if (touchLocation.x < 0 || touchLocation.y<0)return;
//    if (touchLocation.x > self.bounds.size.width || touchLocation.y > self.bounds.size.height)return;

    self.touchStatus = SeekBarTouchStatusNoTouch;
    [super touchesCancelled:touches withEvent:event];
}





- (void)valueChanged
{
    NSNumber *value = [NSNumber numberWithFloat:self.value];
   // NSLog(@"val changed");
    [_valueSignal sendNext:value];


}

- (void)_setValue:(NSNumber *)value animated:(NSNumber *)animated
{
    [self setValue:value.floatValue animated:animated.boolValue];
}
//- (void)fireSeekSignal
//{
//    NSNumber *value = [NSNumber numberWithFloat:self.value];
//    if (self.touchStatus == SeekBarTouchStatusDragging) {
//        [_seekSignal sendNext:value];
//    }
//    
//}

//- (void)setValue:(float)value animated:(BOOL)animated
//{
//    [super setValue:value animated:animated];
//    
//}
//
//
//- (float)value
//{
//    return [super value];
//}
//- (void)setValue:(float)value
//{
//    [super setValue:value];
//    [_valueSignal sendNext:[NSNumber numberWithFloat:self.value]];
//}

//- (RACSignal *)seekWithBarSignal
//{
//    if (!_seekWithBarSignal) {
//        RACSubject *seekWithBarSignal = [RACSubject subject];
//        _seekWithBarSignal = seekWithBarSignal;
//        
//        
//    }
//    
//    return _seekWithBarSignal;
//}
//- (void)setSeekWithBarSignal:(RACSignal *)seekWithBarSignal
//{
//    
//}
@end
