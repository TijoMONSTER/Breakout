//
//  Player.h
//  Breakout
//
//  Created by Iván Mervich on 8/1/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlayerDelegate

- (void)didLoseAllTurns:(id)player;

@end

@interface Player : NSObject

@property NSString *name;
@property int score;
@property int turnsLeft;
@property id<PlayerDelegate> delegate;

- (instancetype)initWithName:(NSString *)name;

- (void)didLoseTurn;
- (void)resetValues;

- (NSString *)compareScoreWithPlayer:(Player *)player;

@end
