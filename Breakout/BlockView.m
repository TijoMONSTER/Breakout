//
//  BlockView.m
//  Breakout
//
//  Created by Iván Mervich on 8/1/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "BlockView.h"
#import "RandomColorGenerator.h"

@interface BlockView ()

@property int numberOfHits;
@property UILabel *hitCountLabel;

@end

@implementation BlockView

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color
{
	self = [super initWithFrame:frame];
	self.backgroundColor = color;

	self.dynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
	self.dynamicBehavior.allowsRotation = YES;
	self.dynamicBehavior.elasticity = 1.0;
	self.dynamicBehavior.density = 1000;

	self.numberOfHits = (arc4random() % 3) + 1;

	NSLog(@"numHits %d", self.numberOfHits);

	self.hitCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	self.hitCountLabel.textAlignment = NSTextAlignmentCenter;
	[self updateHitCountLabelText];
	[self addSubview:self.hitCountLabel];
	self.hitCountLabel.font = [UIFont systemFontOfSize:self.frame.size.height - 1];

	return self;
}

- (void)hit
{
	[UIView animateWithDuration:0.3 animations:^{
		self.backgroundColor = [RandomColorGenerator randomColor];
	}];

	// hits > 0: update label, else: destroy!
	(-- self.numberOfHits > 0) ? [self updateHitCountLabelText] : [self animateDestruction];
}

- (void)updateHitCountLabelText
{
	self.hitCountLabel.text = [NSString stringWithFormat:@"%d", self.numberOfHits];
}

- (void)animateDestruction
{
	[self.hitCountLabel removeFromSuperview];

	[UIView animateWithDuration:0.05
					 animations:^{
						 // make it bigger and change color
						 [self setFrame:CGRectMake(self.frame.origin.x,
												   self.frame.origin.y,
												   self.frame.size.width * 1.2,
												   self.frame.size.height * 1.2)];
						 self.backgroundColor = [RandomColorGenerator randomColor];
					 }
					 completion:^(BOOL finished) {
						 // make it smaller and change color
						 [UIView animateWithDuration:0.1 animations:^{
							 self.alpha = 0.0;
							 [self setFrame:CGRectMake(self.frame.origin.x,
													   self.frame.origin.y,
													   self.frame.size.width / 3,
													   self.frame.size.height / 3)];
							 self.backgroundColor = [RandomColorGenerator randomColor];
						 }
										  completion:^(BOOL finished) {
											  [self.delegate destructionAnimationCompletedWithBlockView:self];
										  }];
					 }];
}
@end
