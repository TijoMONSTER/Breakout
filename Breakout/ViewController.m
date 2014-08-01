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
	UIDynamicItemBehavior *ballDynamicBehavior;
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
	collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
	collisionBehavior.collisionDelegate = self;
	collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
	[dynamicAnimator addBehavior:collisionBehavior];

	paddleDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.paddleView]];
	paddleDynamicBehavior.allowsRotation = NO;
	paddleDynamicBehavior.density = 1000;
	[dynamicAnimator addBehavior:paddleDynamicBehavior];

	ballDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ballView]];
	ballDynamicBehavior.elasticity = 1.0;
	ballDynamicBehavior.friction = 0;
	ballDynamicBehavior.resistance = 0;
	ballDynamicBehavior.allowsRotation = NO;
	[dynamicAnimator addBehavior:ballDynamicBehavior];
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
	self.paddleView.center = CGPointMake([panGestureRecognizer locationInView:self.view].x, self.paddleView.center.y);
	[self.paddleView updatePaddleLocation];
}


@end
