//
//  rpMainViewController.m
//  ReactiveMediaPlayerDemo
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import "rpMainViewController.h"
#import "dpVideoPlayer.h"

@interface rpMainViewController ()

@end

@implementation rpMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashboardBG"]];

    dpVideoPlayer *videoPlayer = [dpVideoPlayer videoPlayer];
    RAC(videoPlayer,maxSize) = [RACSignal if:[self.interfaceOrientationSignal map:^id(NSNumber *interfaceOrientation) {
        return @(UIInterfaceOrientationIsPortrait(interfaceOrientation.integerValue));
    }] then:[RACSignal return:[NSValue valueWithCGSize:CGSizeMake(280, 280)]]
       else:[RACSignal return:[NSValue valueWithCGSize:CGSizeMake(400, 280)]]];
  
    videoPlayer.backgroundColor = [UIColor orangeColor];

    videoPlayer.layer.masksToBounds = NO;
    videoPlayer.layer.shadowColor = [UIColor blackColor].CGColor;
    videoPlayer.layer.shadowOpacity = .8;
    videoPlayer.layer.shadowRadius = 6;
    videoPlayer.layer.shadowOffset = CGSizeMake( 0 , -18 );
    videoPlayer.layer.shouldRasterize = YES;
    
    @weakify(videoPlayer);
    [[videoPlayer.rcl_alignmentRectSignal deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSValue *vidAligRect) {
         @strongify(videoPlayer);
         
         UIBezierPath *shadowPath =
         [UIBezierPath bezierPathWithOvalInRect:CGRectMake( -10 , CGRectGetHeight(vidAligRect.CGRectValue) + 40 ,
                                                           CGRectGetWidth(vidAligRect.CGRectValue) + 20 , 10 ) ];
         [videoPlayer.layer setShadowPath:shadowPath.CGPath];
         
     }];
    //NSValue *whatSize = MEDBox(videoPlayer.maxSize);
//    RACSignal *startWidth = [RACSignal return:[NSNumber numberWithFloat:videoPlayer.maxSize.width]];
//    RACSignal *startHeight = [RACSignal return:[NSNumber numberWithFloat:videoPlayer.maxSize.height]];
//    RACSignal *maxSizeSignal = [RACSignal sizesWithWidth:startWidth height:startHeight];
//    
//    RACSignal *startRect = [RACSignal rectsWithSize:[RACSignal return:[NSValue valueWithCGSize:videoPlayer.maxSize]]];
    NSValue *startSize = MEDBox(videoPlayer.maxSize);
//    RAC(videoPlayer,rcl_bounds) = [RACSignal if:[self.interfaceOrientationSignal map:^id(NSNumber *interfaceOrientation) {
//        return UIInterfaceOrientationIsPortrait(interfaceOrientation.integerValue);
//    }] then:[RACSignal rectsWithSize:[videoPlayer.videoScaledSizeSignal startWith:startSize]] else:RACTupleNil.tupleNil];
    RAC(videoPlayer,rcl_bounds) = [RACSignal rectsWithSize:[videoPlayer.videoScaledSizeSignal startWith:startSize]];
    RAC(videoPlayer,rcl_alignmentRect) = [[videoPlayer.rcl_boundsSignal alignCenterX:self.view.rcl_boundsSignal.centerX] alignTop:[self.view.rcl_boundsSignal.top plus:[RACSignal return:@20]]];
    
//    [videoPlayer.videoScaledSizeSignal subscribeNext:^(id x) {
//        NSLog(@"trans size final: %@",x);
//    }];
//    [videoPlayer.rcl_boundsSignal subscribeNext:^(id x) {
//        NSLog(@"vid bounds: %@",x);
//    }];
    RPPlayer *player = [RPPlayer playerWithURL:[[NSBundle mainBundle] URLForResource:@"Syndicate DART 6 Chip Infomercial (HD)" withExtension:@"mp4"]];
    videoPlayer.player = player;
    
    [self.view addSubview:videoPlayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
