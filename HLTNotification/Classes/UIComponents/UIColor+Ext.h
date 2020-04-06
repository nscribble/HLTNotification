//
//  UIColor+Ext.h
//  HLTNotification
//
//  Created by nscribble on 2017/12/20.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define HTColor(aHexString)                [UIColor colorWithHexString:aHexString]

@interface UIColor (Ext)

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

@end

NS_ASSUME_NONNULL_END
