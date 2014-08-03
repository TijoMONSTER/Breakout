//
//  VisualTimer.m
//  Breakout
//
//  Created by Iván Mervich on 8/3/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "VisualTimer.h"

@interface VisualTimer ()

@property float timeInSeconds;
@property UILabel *timerLabel;

@end

@implementation VisualTimer

- (id)initWithFrame:(CGRect)frame timeInSeconds:(float)time
{
    self = [super initWithFrame:frame];
    if (self) {
		self.userInteractionEnabled = NO;

		self.timeInSeconds = time;

		self.timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		self.timerLabel.textColor = [UIColor whiteColor];
		self.timerLabel.textAlignment = NSTextAlignmentCenter;
		self.timerLabel.font = [UIFont systemFontOfSize:200];
		self.timerLabel.text = [NSString stringWithFormat:@"%d", (int) self.timeInSeconds];
		[self addSubview:self.timerLabel];

		self.alpha = 0.0;
		[UIView animateWithDuration:0.2 animations:^{
			self.alpha = 1.0;
		}
						 completion:^(BOOL finished) {
			[self setTimer];
		}];
    }
    return self;
}

- (void)setTimer
{
	[NSTimer scheduledTimerWithTimeInterval:1
									 target:self
								   selector:@selector(onTimer:)
								   userInfo:nil
									repeats:YES];
}

- (void)onTimer:(NSTimer *)timer
{
	self.alpha = 0;
	if (-- self.timeInSeconds > 0) {
		self.timerLabel.text = [NSString stringWithFormat:@"%d", (int)self.timeInSeconds];
		[UIView animateWithDuration:0.2 animations:^{
			self.alpha = 1.0;
		}];
	}
	else {
		[timer invalidate];
		[self.delegate didCompleteVisualTimer:self];
	}
}

@end
