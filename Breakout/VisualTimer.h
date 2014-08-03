//
//  VisualTimer.h
//  Breakout
//
//  Created by Iván Mervich on 8/3/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VisualTimerDelegate

- (void)didCompleteVisualTimer:(id)timer;

@end

@interface VisualTimer : UIView

@property id<VisualTimerDelegate> delegate;

- (id)initWithFrame:(CGRect)frame timeInSeconds:(float)time;

@end
