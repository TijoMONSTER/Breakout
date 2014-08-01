//
//  BlockView.m
//  Breakout
//
//  Created by Iván Mervich on 8/1/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "BlockView.h"

@implementation BlockView

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color
{
	self = [super initWithFrame:frame];
	self.backgroundColor = color;

	self.dynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
	self.dynamicBehavior.allowsRotation = NO;
	self.dynamicBehavior.density = 1000;

	return self;
}
@end
