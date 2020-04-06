//
//  HLTNotificationSlideView.m
//  HLTNotification
//
//  Created by nscribble on 2017/12/20.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//

#import "HLTNotificationSlideView.h"
#import "HLTNotificationSlideContentView.h"
#import <Masonry/Masonry.h>
#import <RNTimer/RNTimer.h>
#import "HLTNotification+Private.h"

#pragma mark - HLTNotificationSlideView

@interface HLTNotificationSlideView ()

@property (nonatomic, strong) HLTNotificationSlideViewLayout *layout;
@property (nonatomic, strong) HLTNotificationSlideContentView *contentView;

/* 交互相关配置属性 */
//! 是否允许slide关闭
@property (nonatomic, assign) BOOL slideDismissingEnabled;
//! 是否允许向下slide（自定义交互）
@property (nonatomic, assign) BOOL slideDownEnabled;
//! 手势识别器
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
//! 点击
@property (nonatomic, strong) UITapGestureRecognizer *tap;
//! 手势接触起始位置
@property (nonatomic, assign) CGPoint startPoint;
//! 自动取消timer
@property (nonatomic, strong) RNTimer *timer;
//! 超过展示时间
@property (nonatomic, assign) BOOL timeElapsed;
//! 关闭原因
@property (nonatomic, assign) HLTNotificationDismissReason dismissReason;

@property (nonatomic, assign) BOOL isTapHandled;

@end

@implementation HLTNotificationSlideView

+ (instancetype)viewForNotification:(HLTNotification *)notification {
    return [[self alloc] initWithNotification:notification];
}

- (instancetype)initWithNotification:(HLTNotification * _Nullable)notification {
    if (self = [super initWithNotification:notification]) {
        _layout = [[HLTNotificationSlideViewLayout alloc] initWithNotification:notification];
        _contentView = [HLTNotificationSlideContentView contentViewForLayout:_layout];
        
        [self ht_addSubviews];
    }
    
    return self;
}

- (void)ht_addSubviews {
    [self addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.contentView addGestureRecognizer:self.tap];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview && !self.superview) {
        self.slideDismissingEnabled = YES;
    }
}

#pragma mark -

- (void)setSlideDismissingEnabled:(BOOL)slideDismissingEnabled {
    if (_slideDismissingEnabled == slideDismissingEnabled) {
        return;
    }
    
    _slideDismissingEnabled = slideDismissingEnabled;
    if (slideDismissingEnabled) {
        [self addGestureRecognizer:self.pan];
    }
    else if (_pan.view == self) {
        [self removeGestureRecognizer:_pan];
    }
}

#pragma mark -

- (UIPanGestureRecognizer *)pan {
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    }
    
    return _pan;
}

- (UITapGestureRecognizer *)tap {
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    }
    
    return _tap;
}

#pragma mark - 手势识别

- (void)onTap:(UITapGestureRecognizer *)tap {
    if (self.isTapHandled) {
        return;
    }
    
    self.isTapHandled = YES;
    if (tap.state == UIGestureRecognizerStateRecognized) {
        NSDictionary *info = self.notification.payload;
        if ([self.delegate respondsToSelector:@selector(notificationView:takeAction:actionInfo:)]) {
            [self.delegate notificationView:self takeAction:@"actionHaha" actionInfo:info];
        }
    }
}

- (void)onPan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:self];
    CGFloat deltaY = point.y - self.startPoint.y;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            self.startPoint = point;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGRect frame = self.contentView.frame;
            CGFloat maxDragY = 80/2;
            
            if (deltaY <= 0) {
                frame.origin.y = deltaY > 0 ? 0 : deltaY;
                self.contentView.frame = frame;
            }
            else if(self.slideDownEnabled){
                CGFloat y = deltaY;
                y = [self decayY:y delta:deltaY];
                y = MIN(y, maxDragY);
                frame.origin.y = y;
                self.contentView.frame = frame;
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            CGFloat height = CGRectGetHeight(self.contentView.frame);
            BOOL shouldDismiss = NO;
            
            if (self.timeElapsed) {// 超时
                self.dismissReason = HLTNotificationDismissOnTimeout;
                shouldDismiss = YES;
            }
            else if (deltaY < 0) {
                CGFloat const kVelocityToDismiss = 100.f;
                CGPoint velocity = [pan velocityInView:self];
                if ((-deltaY) >= height / 2) {
                    shouldDismiss = YES;
                }
                else if (fabs(velocity.y) >= kVelocityToDismiss) {
                    shouldDismiss = YES;
                }
                
                if (shouldDismiss) {
                    self.dismissReason = HLTNotificationDismissByUser;
                }
            }
            
            if (shouldDismiss) {
                [self dismiss];
            }
            else {
                [self recover];
            }
            break;
        }
            
        default:
            break;
    }
}

- (void)recover {
    CGRect frame = self.contentView.frame;
    if (CGRectGetMinY(frame) == 0) {
        return;
    }
    
    frame.origin.y = 0;
    
    // 动画
    [UIView animateWithDuration:0.25
                          delay:0
                        options:7<<16 | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.contentView.frame = frame;
                     } completion:^(BOOL finished) {
                     }];
}

// log型衰减曲线（随便调
- (CGFloat)decayY:(CGFloat)y delta:(CGFloat)delta {
    CGFloat athird = y / 3;
    return athird + (y - athird) * ((1 + 2 * log(delta) / delta) / 3);
}

#pragma mark -

- (CGFloat)contentHeight {
    return 240/2;
}

- (void)show {//todo: 使用单独的window，并且同一时间只允许一个通知
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat width = CGRectGetWidth(window.bounds);
    CGFloat height = [self contentHeight];
    
    CGRect frame = CGRectMake(0, -height, width, height);
    self.frame = frame;
    
    [window addSubview:self];
    
    frame.origin.y = 0;
    // 动画
    [UIView animateWithDuration:0.25 delay:0 options:7<<16 animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {// on showing
    }];
    
    [self startAutoDismissTimer];
}

- (void)dismiss {
    if (!self.superview) {
        return;
    }
    
    CGRect frame = self.contentView.frame;
    CGRect originFrame = frame;
    frame.origin.y = CGRectGetMinY(self.bounds) - CGRectGetHeight(frame);
    
    // 动画
    [UIView animateWithDuration:0.25
                          delay:0
                        options:7<<16
                     animations:^{
                         self.contentView.frame = frame;
                     } completion:^(BOOL finished) {// on dismissing
                         [self removeFromSuperview];
                         self.contentView.frame = originFrame;
                         
                         if ([self.delegate respondsToSelector:@selector(notificationView:dismissed:)]) {
                             [self.delegate notificationView:self dismissed:self.dismissReason];
                         }
                     }];
}

- (void)startAutoDismissTimer {
    if (self.timer) {
        [self.timer invalidate];
    }
    
    weakify(self);
    NSTimeInterval duration = self.notification.duration;
    
    self.timer = [RNTimer repeatingTimerWithTimeInterval:duration block:^{
        strongify(self);
        [self.timer invalidate];
        self.timer = nil;
        self.timeElapsed = YES;
        if (self.pan.state != UIGestureRecognizerStateBegan &&
            self.pan.state != UIGestureRecognizerStateChanged) {
            
            self.dismissReason = HLTNotificationDismissOnTimeout;
            [self dismiss];
        }
    }];
}

@end
