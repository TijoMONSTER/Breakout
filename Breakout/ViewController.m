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
#import "RandomColorGenerator.h"

@interface ViewController () <PaddleViewDelegate, UICollisionBehaviorDelegate, BlockViewDelegate>
{
	UIDynamicAnimator *dynamicAnimator;
	UIPushBehavior *pushBehavior;
	UICollisionBehavior *collisionBehavior;
	UIDynamicItemBehavior *paddleDynamicBehavior;
	UIDynamicItemBehavior *ballDynamicBehavior;
}

@property (weak, nonatomic) IBOutlet PaddleView *paddleView;
@property (weak, nonatomic) IBOutlet BallView *ballView;

@property NSMutableArray *blocks;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.blocks = [NSMutableArray array];
	self.paddleView.delegate = self;

	[self resetBallPositionAndUpdateDynamicAnimator];
	[self addBlocks];
	[self setTimer];
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
		[self resetBallPositionAndUpdateDynamicAnimator];
	}
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
	BlockView *block;

	if ([item1 isKindOfClass:[BlockView class]] &&
		[item2 isEqual:self.ballView]) {
		block = (BlockView *)item1;
	}
	else if ([item2 isKindOfClass:[BlockView class]] &&
			 [item1 isEqual:self.ballView]) {
		block = (BlockView *)item2;
	}

	// if a block was hit
	if (block != nil) {
		[block hit];
	}
}

#pragma mark IBActions

- (IBAction)dragPaddle:(UIPanGestureRecognizer *)panGestureRecognizer
{
	self.paddleView.center = CGPointMake([panGestureRecognizer locationInView:self.view].x,
										 self.paddleView.center.y);

	[self.paddleView updatePaddleLocation];
}

#pragma mark BlockViewDelegate

-(void)destructionAnimationCompletedWithBlockView:(id)block
{
	[self removeBlock:block];

	if ([self shouldStartAgain]) {
		NSLog(@"Should start again");
		[self resetBallPositionAndUpdateDynamicAnimator];
		[dynamicAnimator removeAllBehaviors];

		[self addBlocks];
		[self setTimer];
	}
}

#pragma mark Helper methods
- (void)addBlocks
{
	BlockView *block;

	int numberOfBlocksToAdd = 3;
	CGSize blockSize = CGSizeMake(100, 30);

	for (int i = 0; i < numberOfBlocksToAdd; i++) {
		block = [[BlockView alloc] initWithFrame:CGRectMake(
															// if it's not the first element, add 1 point of space between elements
															(i == 0) ? 0 : (i * blockSize.width) + (i + 1),
															20,
															blockSize.width,
															blockSize.height)
										   color: [RandomColorGenerator randomColor]];

		[self.view addSubview:block];
		[self.blocks addObject:block];
		block.delegate = self;
	}
}

- (BOOL)shouldStartAgain
{
	return [self.blocks count] == 0;
}

- (void)addBehaviors
{
	dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

	pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.ballView]
													mode:UIPushBehaviorModeInstantaneous];

	pushBehavior.pushDirection = CGVectorMake(0.5, 1.0);
	pushBehavior.active = YES;
	pushBehavior.magnitude = 0.02;
	[dynamicAnimator addBehavior:pushBehavior];

	collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.paddleView, self.ballView]];
	collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
	collisionBehavior.collisionDelegate = self;
	collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;

	// add lower boundary
	[collisionBehavior addBoundaryWithIdentifier:@"lowerBoundary"
									   fromPoint:CGPointMake(0.0, self.view.frame.size.height)
										 toPoint:CGPointMake(self.view.frame.size.width, self.view.frame.size.height)];

	[dynamicAnimator addBehavior:collisionBehavior];

	paddleDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.paddleView]];
	paddleDynamicBehavior.allowsRotation = NO;
	paddleDynamicBehavior.density = 1000;
	paddleDynamicBehavior.elasticity = 1.0;
	[dynamicAnimator addBehavior:paddleDynamicBehavior];

	ballDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ballView]];
	ballDynamicBehavior.elasticity = 1.0;
	ballDynamicBehavior.friction = 0;
	ballDynamicBehavior.resistance = 0;
	ballDynamicBehavior.allowsRotation = NO;
	[dynamicAnimator addBehavior:ballDynamicBehavior];

		// blocks
	for (BlockView *block in self.blocks) {
		[dynamicAnimator addBehavior:block.dynamicBehavior];
		[collisionBehavior addItem:block];
	}
}

- (void)resetBallPositionAndUpdateDynamicAnimator
{
	self.ballView.center = self.view.center;
	[dynamicAnimator updateItemUsingCurrentState:self.ballView];
}

- (void)setTimer
{
	[NSTimer scheduledTimerWithTimeInterval:3.0
									 target:self
								   selector:@selector(onTimer:)
								   userInfo:nil
									repeats:NO];
}

- (void)onTimer:(NSTimer *)timer
{
	[timer invalidate];
	timer = nil;

	[self addBehaviors];
}

- (void)removeBlock:(BlockView *)block
{
	[self.blocks removeObject:block];
	[dynamicAnimator removeBehavior:block.dynamicBehavior];
	[collisionBehavior removeItem:block];
	[block removeFromSuperview];

}

@end
