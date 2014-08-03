//
//  Player.h
//  Breakout
//
//  Created by Iván Mervich on 8/1/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property NSString *name;
@property int score;

- (instancetype)initWithName:(NSString *)name;

@end
