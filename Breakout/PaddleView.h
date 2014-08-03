//
//  PaddleView.h
//  Breakout
//
//  Created by Iván Mervich on 7/31/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PaddleViewDelegate

- (void)didUpdateLocationForPaddle:(id)paddleView;

@end

@interface PaddleView : UIView

@property id<PaddleViewDelegate> delegate;

- (void)updatePaddleCenterWithPoint:(CGPoint)point;

@end
