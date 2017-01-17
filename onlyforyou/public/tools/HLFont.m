//
//  HLFont.m
//  onlyforyou
//
//  Created by honghao5 on 17/1/4.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import "HLFont.h"

@implementation HLFont

+ (UIFont *)fontWithSize:(CGFloat)fontSize
{
    return [UIFont systemFontOfSize:fontSize];
}

+ (UIFont *)titleFont
{
    return [HLFont fontWithSize:16];
}

@end
