//
//  RandomColorGenerator.m
//  Breakout
//
//  Created by Iván Mervich on 8/1/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "RandomColorGenerator.h"

@implementation RandomColorGenerator

+ (UIColor *)randomColor
{
	float red = (float) rand() / RAND_MAX;
	float green = (float) rand() / RAND_MAX;
	float blue = (float) rand() / RAND_MAX;
	return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

@end
