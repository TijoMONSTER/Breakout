//
//  PaddleView.m
//  Breakout
//
//  Created by Iván Mervich on 7/31/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "PaddleView.h"

@implementation PaddleView

- (void)updatePaddleCenterWithPoint:(CGPoint)point
{
	self.center = point;
	[self.delegate didUpdateLocationForPaddle:self];
}

@end
