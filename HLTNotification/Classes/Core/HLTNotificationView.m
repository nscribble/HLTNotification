//
//  HLTNotificationView.m
//  HLTNotification
//
//  Created by nscribble on 2017/12/15.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//

#import "HLTNotificationView.h"
#import "HLTNotificationManager+Private.h"

@interface HLTNotificationView ()

@property (nonatomic,weak,readwrite) id<HLTNotificationViewDelegate> delegate;
@property (nonatomic,strong,readwrite) HLTNotification *notification;

@end

@implementation HLTNotificationView

+ (HLTNotificationView *)viewForNotification:(HLTNotification *)notification {
    HLTNotificationView *view = [[self alloc] initWithNotification:notification];
    
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [self initWithNotification:nil]) {
        self.frame = frame;
    }
    
    return self;
}

- (instancetype)initWithNotification:(HLTNotification *_Nullable)notification {
    if (self = [super initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 290/2)]) {
        _notification = notification;
        _delegate = [HLTNotificationManager sharedInstance];
    }
    
    return self;
}

- (void)show {
    
}

- (void)dismiss {
    
}

@end
