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
#import "Player.h"
#import "VisualTimer.h"

@interface ViewController () <PaddleViewDelegate, UICollisionBehaviorDelegate, BlockViewDelegate, UIAlertViewDelegate, BallViewDelegate, PlayerDelegate, VisualTimerDelegate>
{
	UIDynamicAnimator *dynamicAnimator;
	UIPushBehavior *pushBehavior;
	UICollisionBehavior *collisionBehavior;
	UIDynamicItemBehavior *paddleDynamicBehavior;
	UIDynamicItemBehavior *ballDynamicBehavior;
}

@property (weak, nonatomic) IBOutlet PaddleView *paddleView;
@property (weak, nonatomic) IBOutlet BallView *ballView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *turnsLabel;

@property NSMutableArray *blocks;

@property Player *currentPlayer;
@property NSArray *players;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.blocks = [NSMutableArray array];
	self.paddleView.delegate = self;
	self.ballView.delegate = self;

	Player *player1 = [[Player alloc] initWithName:@"Player 1"];
	player1.delegate = self;
	Player *player2 = [[Player alloc] initWithName:@"Player 2"];
	player2.delegate = self;
	
	self.players = @[player1, player2];
	self.currentPlayer = player1;

	[self updateScoreAndTurnsLabels];
	[self resetBallPositionAndUpdateDynamicAnimator];
	[self addBlocksAndSetTimer];
}

#pragma mark PaddleViewDelegate

- (void)didUpdateLocationForPaddle:(id)paddleView
{
	[dynamicAnimator updateItemUsingCurrentState:paddleView];
}

#pragma mark UICollisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
	if ([(NSString *)identifier isEqualToString: @"lowerBoundary"]) {
		[self.ballView didFallOffTheLowerBoundary];
		[self removeAllBlocks];
		[self resetBallPositionAndRemoveBehaviors];
		[self.currentPlayer loseTurn];
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

#pragma mark BlockViewDelegate

- (void)scoreForHit:(int)score
{
	self.currentPlayer.score += score;
	[self updateScoreAndTurnsLabels];
}

-(void)destructionAnimationCompletedWithBlockView:(id)block
{
	[self removeBlock:block];

	if ([self shouldStartAgain]) {

		// stop everything
		[self resetBallPositionAndRemoveBehaviors];

		UIAlertView *alertView = [[UIAlertView alloc] init];
		alertView.delegate = self;
		alertView.title = @"Game Over";
		alertView.message = @"Want to try again?";
		[alertView addButtonWithTitle:@"OK"];
		[alertView show];
	}
}

#pragma mark BallViewDelegate

- (void)scoreForFallenBall:(int)score
{
	// don't show negative scores
	if (self.currentPlayer.score >= score) {
		self.currentPlayer.score -= score;
	} else {
		self.currentPlayer.score = 0;
	}

	[self updateScoreAndTurnsLabels];
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	// reset player scores
	for (Player *player in self.players) {
		[player resetValues];
	}

	// set first player as current
	if ([self.currentPlayer isEqual:[self.players lastObject]]) {
		[self setNextPlayer];
	}

	[self addBlocksAndSetTimer];
}

#pragma mark PlayerDelegate

- (void)didLoseTurn:(id)player
{
	// game not finished yet
	[self setNextPlayer];
	[self addBlocksAndSetTimer];
}

- (void)didLoseAllTurns:(id)player
{
	Player *lastPlayerInArray = (Player *)[self.players lastObject];

	// if the current player was the last player in the array
	if ([lastPlayerInArray isEqual:player]) {
		// stop everything
		[self resetBallPositionAndRemoveBehaviors];

		Player *firstPlayerInArray = (Player *)[self.players firstObject];
		NSString *scoreComparingResult = [firstPlayerInArray compareScoreWithPlayer:lastPlayerInArray];
		NSString *alertMessage;

		if ([scoreComparingResult isEqualToString:@"win"]) {
			// first player wins
			alertMessage = [NSString stringWithFormat:@"Final score: %d - %d \nThe winner is: %@\n Want to try again?",
							firstPlayerInArray.score,
							lastPlayerInArray.score,
							firstPlayerInArray.name];
		} else if ([scoreComparingResult isEqualToString:@"lose"]) {
			// second player wins
			alertMessage = [NSString stringWithFormat:@"Final score: %d - %d \nThe winner is: %@\n Want to try again?",
							firstPlayerInArray.score,
							lastPlayerInArray.score,
							lastPlayerInArray.name];
		} else {
			// draw
			alertMessage = [NSString stringWithFormat:@"Final score: %d - %d \nIt was a draw!\n Want to try again?",
							firstPlayerInArray.score,
							lastPlayerInArray.score];
		}

		UIAlertView *alertView = [[UIAlertView alloc] init];
		alertView.delegate = self;
		alertView.title = @"No more turns left!";
		alertView.message = alertMessage;
		[alertView addButtonWithTitle:@"OK"];
		[alertView show];
	}
	else {
		// game not finished yet
		[self setNextPlayer];
		[self addBlocksAndSetTimer];
	}
}

#pragma mark VisualTimerDelegate

- (void)didCompleteVisualTimer:(id)timer
{
	[UIView animateWithDuration:1 animations:^{
		self.ballView.alpha = 1.0;
	} completion:^(BOOL finished) {
		NSLog(@"did complete visual timer");
		VisualTimer *visualTimer = (VisualTimer *)timer;
		visualTimer.delegate = nil;
		[visualTimer removeFromSuperview];

		self.ballView.hidden = NO;
		[self addBehaviors];
	}];
}

#pragma mark IBActions

- (IBAction)dragPaddle:(UIPanGestureRecognizer *)panGestureRecognizer
{
	[self.paddleView updatePaddleCenterWithPoint: CGPointMake([panGestureRecognizer locationInView:self.view].x,
															  self.paddleView.center.y)];
}

#pragma mark Helper methods

- (void)removeAllBlocks
{
	for (BlockView *block in self.blocks) {
		[block removeFromSuperview];
		block.delegate = nil;
		[dynamicAnimator removeBehavior:block.dynamicBehavior];
		[collisionBehavior removeItem:block];
	}
	
	[self.blocks removeAllObjects];
}

- (void)addBlocksAndSetTimer
{
	[self addBlocks];
	[self setVisualTimer];
}

- (void)addBlocks
{
	int topPadding = 90;
	int sidePadding = 12;

	CGPoint initialPoint = CGPointMake(sidePadding, topPadding);

	// substract padding on each side
	float screenWidth = self.view.frame.size.width - (sidePadding * 2);

	int numberOfBlocksPerLine = 7;
	int numberOfLines = 10;

	// blocks have 1 point space between each other
	CGSize blockSize = CGSizeMake(((screenWidth - (numberOfBlocksPerLine + 1)) / numberOfBlocksPerLine), 10);

	for (int line = 0; line < numberOfLines; line++) {
		for (int i = 0; i < numberOfBlocksPerLine; i++) {

			BlockView *block = [[BlockView alloc] initWithFrame:CGRectMake(initialPoint.x + ((blockSize.width + 1) * i),
																		   initialPoint.y + ((blockSize.height + 1) * line),
																		   blockSize.width,
																		   blockSize.height)];
			[self.view addSubview:block];
			[self.blocks addObject:block];
			block.delegate = self;
		}
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

	pushBehavior.pushDirection = CGVectorMake((arc4random() % 2) == 0 ? - 0.5 : 0.5, 1.0);
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

- (void) resetBallPositionAndRemoveBehaviors
{
	[self resetBallPositionAndUpdateDynamicAnimator];
	[dynamicAnimator removeAllBehaviors];
}

- (void)resetBallPositionAndUpdateDynamicAnimator
{
	self.ballView.center = self.view.center;
	[dynamicAnimator updateItemUsingCurrentState:self.ballView];
}

- (void)setVisualTimer
{
	[UIView animateWithDuration:1 animations:^{
		self.ballView.alpha = 0.0;
	} completion:^(BOOL finished) {
		NSLog(@"set visual timer");
		VisualTimer *timer = [[VisualTimer alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) timeInSeconds:3.0];
		timer.delegate = self;
		[self.view addSubview:timer];
	}];
}

- (void)removeBlock:(BlockView *)block
{
	[self.blocks removeObject:block];
	[dynamicAnimator removeBehavior:block.dynamicBehavior];
	[collisionBehavior removeItem:block];
	[block removeFromSuperview];
	block.delegate = nil;
}

- (void)setNextPlayer
{
	int currentPlayerIndex = [self.players indexOfObject:self.currentPlayer];

	if (++currentPlayerIndex == [self.players count]) {
		self.currentPlayer = [self.players objectAtIndex:0];
	}
	else {
		self.currentPlayer = [self.players objectAtIndex:currentPlayerIndex];
	}

	[self updateScoreAndTurnsLabels];
}

- (void)updateScoreAndTurnsLabels
{
	self.scoreLabel.text = [NSString stringWithFormat:@"%@ score: %d", self.currentPlayer.name, self.currentPlayer.score];
	self.turnsLabel.text = [NSString stringWithFormat:@"%d", self.currentPlayer.turnsLeft];
}

@end
