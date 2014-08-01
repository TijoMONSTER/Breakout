//
//  ViewController.m
//  Breakout
//
//  Created by Iván Mervich on 7/31/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "ViewController.h"
#import "PaddleView.h"
#import "BallView.h"

@interface ViewController () <PaddleViewDelegate>
{
	UIDynamicAnimator *dynamicAnimator;
	UIPushBehavior *pushBehavior;
}

@property (weak, nonatomic) IBOutlet PaddleView *paddleView;
@property (weak, nonatomic) IBOutlet BallView *ballView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.paddleView.delegate = self;

	dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

	pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.ballView] mode:UIPushBehaviorModeInstantaneous];
	pushBehavior.pushDirection = CGVectorMake(0.5, 1.0);
	pushBehavior.active = YES;
	pushBehavior.magnitude = 0.1;
	[dynamicAnimator addBehavior:pushBehavior];
}

#pragma mark PaddleViewDelegate

- (void)updatedLocationForPaddle
{
	[dynamicAnimator updateItemUsingCurrentState:self.paddleView];
}

#pragma mark IBActions

- (IBAction)dragPaddle:(UIPanGestureRecognizer *)panGestureRecognizer
{
	CGPoint translation = [panGestureRecognizer translationInView:self.view];

	self.paddleView.center = CGPointMake(self.paddleView.center.x + translation.x, self.paddleView.center.y);
	[panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];

	[self.paddleView updatePaddleLocation];
}


@end
