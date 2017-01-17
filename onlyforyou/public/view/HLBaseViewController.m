//
//  HLBaseViewController.m
//  onlyforyou
//
//  Created by honghao5 on 17/1/4.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import "HLBaseViewController.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>

@interface HLBaseViewController ()

@property (nonatomic, strong) UIView *backgroudView;

@end

@implementation HLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.view addSubview:self.backgroudView];
}

- (UIView *)backgroudView
{
    if (!_backgroudView) {
        _backgroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenBounds.size.width, 64)];
        _backgroudView.backgroundColor = [HLColor navigationColor];
    }
    return _backgroudView;
}

- (void)setNavigationAlpha:(CGFloat)alpha
{
    self.backgroudView.alpha = alpha;
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
