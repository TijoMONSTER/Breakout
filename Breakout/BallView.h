//
//  BallView.h
//  Breakout
//
//  Created by Iván Mervich on 7/31/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BallViewDelegate

- (void)scoreForFallenBall:(int)score;

@end

@interface BallView : UIView

@property id<BallViewDelegate> delegate;

- (void)didFallOffTheLowerBoundary;

@end
