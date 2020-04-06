//
//  UIColor+Ext.m
//  HLTNotification
//
//  Created by nscribble on 2017/12/20.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//

#import "UIColor+Ext.h"

@implementation UIColor (Ext)

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    return [self colorWithHexString:stringToConvert alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(float)alpha {
    NSString *pureString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([pureString length] < 6)
        return [UIColor redColor];
    if ([pureString hasPrefix:@"0X"] || [pureString hasPrefix:@"0x"])
        pureString = [pureString substringFromIndex:2];
    if ([pureString hasPrefix:@"#"])
        pureString = [pureString substringFromIndex:1];
    if ([pureString length] != 6)
        return [UIColor redColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [pureString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [pureString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [pureString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    if (alpha < 0 || alpha > 1.0)
        alpha = 1.0f;
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

@end
