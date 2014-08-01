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

@interface ViewController () <PaddleViewDelegate, UICollisionBehaviorDelegate>
{
	UIDynamicAnimator *dynamicAnimator;
	UIPushBehavior *pushBehavior;
	UICollisionBehavior *collisionBehavior;
	UIDynamicItemBehavior *paddleDynamicBehavior;
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
	pushBehavior.magnitude = 0.2;
	[dynamicAnimator addBehavior:pushBehavior];

	collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.paddleView, self.ballView]];
	collisionBehavior.collisionMode = UICollisionBehaviorModeItems;
	collisionBehavior.collisionDelegate = self;
	collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
	[dynamicAnimator addBehavior:collisionBehavior];

	paddleDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.paddleView]];
	paddleDynamicBehavior.allowsRotation = NO;
	paddleDynamicBehavior.density = 1000;
	[dynamicAnimator addBehavior:paddleDynamicBehavior];
}

#pragma mark PaddleViewDelegate

- (void)updatedLocationForPaddle
{
	[dynamicAnimator updateItemUsingCurrentState:self.paddleView];
}

#pragma mark UICollisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
	NSLog(@"Collision with item");
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
