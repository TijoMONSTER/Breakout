//
//  BlockView.m
//  Breakout
//
//  Created by Iván Mervich on 8/1/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "BlockView.h"
#import "RandomColorGenerator.h"

@implementation BlockView

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color
{
	self = [super initWithFrame:frame];
	self.backgroundColor = color;

	self.dynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
	self.dynamicBehavior.allowsRotation = YES;
	self.dynamicBehavior.elasticity = 1.0;
	self.dynamicBehavior.density = 1000;

	return self;
}

- (void)animateDestruction
{
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
