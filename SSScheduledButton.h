//
//  SSScheduledButton.h
//  StandardProjectTemplate
//
//  Created by CIZ on 2017/11/2.
//  Copyright © 2017年 JSong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSScheduledButton;
@protocol SSScheduledButtonDelegate <NSObject>

- (void)scheduledButton_didTouchupInside:(SSScheduledButton *)button isDuringCountDown:(BOOL)isDuringCountDown;
- (void)scheduledButton_didUpdateWhenCountingDown:(SSScheduledButton *)button withLeftTime:(int)leftTime;
- (void)scheduledButton_didUpdateWhenTimeIsOver:(SSScheduledButton *)button;

@end


@interface SSScheduledButton : UIButton

@property (nonatomic, weak  ) id<SSScheduledButtonDelegate>     delegate;
@property (nonatomic, assign) int                               scheduledTotalTime;

+ (instancetype)customButtonWithType:(UIButtonType)buttonType;

@end
