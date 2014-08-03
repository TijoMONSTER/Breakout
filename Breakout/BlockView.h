//
//  BlockView.h
//  Breakout
//
//  Created by Iván Mervich on 8/1/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BlockViewDelegate

-(void)destructionAnimationCompletedWithBlockView:(id)block;

@end

@interface BlockView : UIView

@property UIDynamicItemBehavior *dynamicBehavior;
@property id<BlockViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)hit;

@end
