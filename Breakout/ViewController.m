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
#import "BlockView.h"

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

	// add lower boundary
	[collisionBehavior addBoundaryWithIdentifier:@"lowerBoundary" fromPoint:CGPointMake(0.0, self.view.frame.size.height) toPoint:CGPointMake(self.view.frame.size.width, self.view.frame.size.height)];

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

	[self addBlocks];
}

#pragma mark PaddleViewDelegate

- (void)updatedLocationForPaddle
{
	[dynamicAnimator updateItemUsingCurrentState:self.paddleView];
}

#pragma mark UICollisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
	if ([(NSString *)identifier isEqualToString: @"lowerBoundary"]) {
		self.ballView.center = self.view.center;
		[dynamicAnimator updateItemUsingCurrentState:self.ballView];
	}

//	if (p.y >= self.view.frame.size.height - 5) {

//	}
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
	if ([item1 isKindOfClass:[BlockView class]] && [item2 isEqual:self.ballView]) {
		[self removeBlockFromSuperview:(BlockView *)item1];
	}
	else if ([item2 isKindOfClass:[BlockView class]] && [item1 isEqual:self.ballView]) {
		[self removeBlockFromSuperview:(BlockView *)item2];
	}
}

#pragma mark IBActions

- (IBAction)dragPaddle:(UIPanGestureRecognizer *)panGestureRecognizer
{
	self.paddleView.center = CGPointMake([panGestureRecognizer locationInView:self.view].x, self.paddleView.center.y);
	[self.paddleView updatePaddleLocation];
}

#pragma mark Helper methods
- (void)addBlocks
{
	BlockView *block;

	int numberOfBlocks = 3;
	CGSize blockSize = CGSizeMake(100, 30);

	for (int i = 0; i < numberOfBlocks; i++) {


		block = [[BlockView alloc] initWithFrame:CGRectMake(
															// if it's not the first element, add 1 point of space between elements
															(i == 0) ? 0 : (i * blockSize.width) + 5,
															20,
															blockSize.width,
															blockSize.height)
										   color: [self randomColor]];

		[self.view addSubview:block];
		[collisionBehavior addItem:block];

	}
}

- (void)removeBlockFromSuperview:(BlockView *)block
{
	[block removeFromSuperview];
}

- (UIColor *)randomColor
{
	float red = (float) rand() / RAND_MAX;
	float green = (float) rand() / RAND_MAX;
	float blue = (float) rand() / RAND_MAX;
	return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

@end
