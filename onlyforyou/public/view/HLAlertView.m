//
//  HLAlertView.m
//  onlyforyou
//
//  Created by honghao5 on 17/1/9.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import "HLAlertView.h"

@implementation HLAlertView

+ (void)showAlertWithMessage:(NSString *)message
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert removeTopCircle];
    alert.backgroundType = SCLAlertViewBackgroundBlur;
    alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;
    [alert showNotice:@"" subTitle:message closeButtonTitle:@"嗷~" duration:0.0f];
}

@end
