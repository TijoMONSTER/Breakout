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

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];

	self.dynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
	self.dynamicBehavior.allowsRotation = NO;
	self.dynamicBehavior.elasticity = 1.0;
	self.dynamicBehavior.density = 1000;

	// random block type from 1 to 4
	self.numberOfHits = (arc4random() % 4) + 1;
	self.backgroundColor = [self colorForNumberOfHits:self.numberOfHits];

	self.hitCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	self.hitCountLabel.textAlignment = NSTextAlignmentCenter;
	[self updateHitCountLabelText];
	self.hitCountLabel.font = [UIFont systemFontOfSize:self.frame.size.height - 1];
	[self addSubview:self.hitCountLabel];

	return self;
}

- (void)hit
{
	// hits > 0: update label, else: destroy!
	if (-- self.numberOfHits > 0) {
		[UIView animateWithDuration:0.3 animations:^{
			self.backgroundColor = [self colorForNumberOfHits:self.numberOfHits];
		}];
		[self updateHitCountLabelText];
	}
	else {
		[self animateDestruction];
	}
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

- (UIColor *)colorForNumberOfHits:(int)hits
{
	UIColor *color;
	switch (hits) {
		default:
		case 1:
			color = [UIColor colorWithRed:169/255.0 green:112/255.0 blue:226/255.0 alpha:1.0];
			break;
		case 2:
			color = [UIColor colorWithRed:120/255.0 green:241/255.0 blue:240/255.0 alpha:1.0];
			break;
		case 3:
			color = [UIColor colorWithRed:235/255.0 green:116/255.0 blue:235/255.0 alpha:1.0];
			break;
		case 4:
			color = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:121/255.0 alpha:1.0];
			break;
	}

	return color;
}

@end
