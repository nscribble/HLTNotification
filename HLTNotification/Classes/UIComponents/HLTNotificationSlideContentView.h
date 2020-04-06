//
//  HLTNotificationSlideContentView.h
//  HLTNotification
//
//  Created by nscribble on 2017/12/20.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//  界面布局信息

#import <UIKit/UIKit.h>

#ifndef __HLTSlideContentViewHeader__
#define __HLTSlideContentViewHeader__

#define weakify(var) __weak typeof(var) AHKWeak_##var = var;
#define strongify(var) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong typeof(var) var = AHKWeak_##var; \
_Pragma("clang diagnostic pop")

#endif


@class HLTNotification;
NS_ASSUME_NONNULL_BEGIN

@interface HLTNotificationSlideViewLayout : NSObject

//! 标题
@property (nonatomic,copy) NSString *title;
//! 副标题
@property (nonatomic,copy) NSString *subtitle;
//! 头像
@property (nonatomic,copy) NSURL *avatarURL;

- (instancetype)initWithNotification:(HLTNotification *)notification;

@end

@interface HLTNotificationSlideContentView : UIView

+ (instancetype)contentViewForLayout:(HLTNotificationSlideViewLayout *)layout;

@end

NS_ASSUME_NONNULL_END
