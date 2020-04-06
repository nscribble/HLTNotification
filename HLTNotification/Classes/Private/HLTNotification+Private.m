//
//  HLTNotification+Private.m
//  HLTNotification
//
//  Created by nscribble on 2017/12/18.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//

#import "HLTNotification+Private.h"

@implementation HLTNotification (Private)

- (CGFloat)minDuration {
    return self.request.option.minDuration;
}

- (CGFloat)duration {
    return self.request.option.duration;
}

- (CGFloat)priority {
    return self.request.option.priority;
}

- (BOOL)isExclusive {
    return self.request.option.exclusive;
}

@end
