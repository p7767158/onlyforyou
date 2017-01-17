//
//  HLNavigationViewController.m
//  onlyforyou
//
//  Created by honghao5 on 17/1/4.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import "HLNavigationViewController.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>

@interface HLNavigationViewController ()

@end

@implementation HLNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBarTintColor:[HLColor navigationColor]];
    
    //TODO: Hg - 两句需配合使用 方能隐藏导航栏下的线
//    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationBar setShadowImage:[UIImage new]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlertWithMessage:(NSString *)message
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert removeTopCircle];
    alert.backgroundType = SCLAlertViewBackgroundBlur;
    alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;
    [alert showNotice:self title:@"" subTitle:message closeButtonTitle:@"嗷~" duration:0.0f];
}

@end
