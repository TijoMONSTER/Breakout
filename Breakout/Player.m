//
//  Player.m
//  Breakout
//
//  Created by Iván Mervich on 8/1/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Player.h"

@implementation Player

- (instancetype)initWithName:(NSString *)name
{
	self = [super init];

	self.name = name;
	[self resetValues];

	return self;
}

- (void)didLoseTurn
{
	if (--self.turnsLeft <= 0) {
		[self.delegate didLoseAllTurns:self];
	}
}

- (NSString *)compareScoreWithPlayer:(Player *)player
{
	NSString *result;

	if (self.score > player.score) {
		result = @"win";
	} else if (player.score > self.score) {
		result = @"lose";
	} else {
		result = @"Draw";
	}
	return result;
}

- (void)resetValues
{
	self.score = 0;
	self.turnsLeft = 3;
}

@end
