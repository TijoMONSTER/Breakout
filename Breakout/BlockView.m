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
	return self;
}
@end
