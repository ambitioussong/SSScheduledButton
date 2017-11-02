//
//  SSScheduledButton.m
//  StandardProjectTemplate
//
//  Created by CIZ on 2017/11/2.
//  Copyright © 2017年 JSong. All rights reserved.
//

#import "SSScheduledButton.h"

static const int SSDefaultScheduledTotalTime = 60;

@interface SSScheduledButton ()

@property (nonatomic, assign) int leftTime;

@end


@implementation SSScheduledButton

+ (instancetype)customButtonWithType:(UIButtonType)buttonType {
    SSScheduledButton *customButton = [super buttonWithType:buttonType];
    [customButton configActions];
    
    return customButton;
}

- (void)configActions {
    [self addTarget:self action:@selector(onScheduledButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onScheduledButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scheduledButton_didTouchupInside:isDuringCountDown:)]) {
        [self.delegate scheduledButton_didTouchupInside:self isDuringCountDown:(self.leftTime > 0)];
    }
    
    if (self.leftTime > 0) {
        return;
    }
    
    self.leftTime = self.scheduledTotalTime ? self.scheduledTotalTime : SSDefaultScheduledTotalTime;
    
    // GCD schedule timer
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // Call every 1 sec
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        if (self.leftTime <= 0 ){
            // The timer is over
            // Shut down the timer
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(scheduledButton_didUpdateWhenTimeIsOver:)]) {
                    [self.delegate scheduledButton_didUpdateWhenTimeIsOver:self];
                }
            });
        } else {
            // The timer is counting down
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(scheduledButton_didUpdateWhenCountingDown:withLeftTime:)]) {
                    [self.delegate scheduledButton_didUpdateWhenCountingDown:self withLeftTime:self.leftTime];
                }
            });
            
            self.leftTime--;
        }
    });
    
    // Start the timer
    dispatch_resume(_timer);
}

@end
