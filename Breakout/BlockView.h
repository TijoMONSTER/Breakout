//
//  BlockView.h
//  Breakout
//
//  Created by Iván Mervich on 8/1/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockView : UIView

@property UIDynamicItemBehavior *dynamicBehavior;

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color;

@end
