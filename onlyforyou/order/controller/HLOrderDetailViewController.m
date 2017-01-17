//
//  HLOrderDetailViewController.m
//  onlyforyou
//
//  Created by honghao5 on 17/1/6.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import "HLOrderDetailViewController.h"
#import "HLOrderDetailViewModel.h"

@interface HLOrderDetailViewController ()

@property (nonatomic, strong) HLOrderDetailViewModel *orderDetailVm;

@end

@implementation HLOrderDetailViewController

- (instancetype)initWithOrderDetailViewModel:(HLOrderDetailViewModel *)orderDetailVm
{
    if (self = [super init]) {
        _orderDetailVm = orderDetailVm;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _orderDetailVm = [[HLOrderDetailViewModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    self.view.backgroundColor = [HLColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
