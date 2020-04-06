//
//  HLTNotificationDef.h
//  HLTNotification
//
//  Created by nscribble on 2017/12/18.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//

#ifndef HLTNotificationDef_h
#define HLTNotificationDef_h

typedef NS_OPTIONS(NSInteger, kInAppNotificationShowOptions) {
    //! 覆盖（其他）
    kInAppNotificationShowOptionOverlay,
    //! 独占（不可被覆盖）
    kInAppNotificationShowOptionExclusive,
};

//! UI展示类型
typedef NS_ENUM(NSInteger, HLTNotificationStyle) {
    //! 方角贴边（参见语音聊天“接收邀请”）
    HLTNotificationStyle1,
    //! 圆角缩进（参见语音聊天“系统推荐用户”）
    HLTNotificationStyle2,
};

typedef NS_ENUM(NSInteger, HLTNotificationDismissReason) {
    // 未知（被打断等）
    HLTNotificationDismissUnknown,
    // Action（Action事件）
    HLTNotificationDismissByAction,
    // 超时关闭
    HLTNotificationDismissOnTimeout,
    // 用户关闭（上滑）
    HLTNotificationDismissByUser,
};

extern void (^__HLTNotificationLogger)(NSString *format, ...);
#define HLTLog(format, ...) {\
    if (NULL != __HLTNotificationLogger) {\
        __HLTNotificationLogger(format, ## __VA_ARGS__);\
    }\
}

#endif /* HLTNotificationDef_h */
