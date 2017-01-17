//
//  HLCashNoteViewController.m
//  onlyforyou
//
//  Created by honghao5 on 17/1/4.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import "HLOrderListViewController.h"
#import "HLOrderListViewModel.h"
#import "HLOrderDetailViewModel.h"
#import "HLOrderDetailViewController.h"
#import "HLOrderListTableViewCell.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import "HLEventSelectViewController.h"

@interface HLOrderListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *list;
@property (nonatomic, strong) HLOrderListViewModel *orderListVm;

@end

@implementation HLOrderListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _orderListVm = [[HLOrderListViewModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"账本";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addOrder:)];
    
    [self.view addSubview:self.list];
    [self.list mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    @weakify(self);
    [[RACObserve(self.orderListVm, orderArray) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        @strongify(self);
        [self.list reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)addOrder:(id)sender
{
    [self.navigationController pushViewController:[[HLEventSelectViewController alloc] init] animated:YES];
}

- (IBAction)showAddView:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    SCLTextView *titleField = [alert addTextField:@"干啥了"];
    
    SCLTextView *moneyField = [alert addTextField:@"花多钱"];
    moneyField.keyboardType = UIKeyboardTypeDecimalPad;
    
    @weakify(self);
    [alert addButton:@"记账" validationBlock:^BOOL{
        NSString *alertStr = @"";
        
        if (titleField.text.length == 0) {
            alertStr = @"不是，啥也没干记啥账?";
        } else if (moneyField.text.doubleValue == 0) {
            alertStr = [NSString stringWithFormat:@"咋的，%@不花钱啊?", titleField.text];
        }
        
        if (alertStr.length > 0) {
            [(HLNavigationViewController *)self.navigationController showAlertWithMessage:alertStr];
            return NO;
        }
        
        return YES;
    } actionBlock:^{
        [[[HLOrderDetailViewModel alloc] init] addOrderWithTitle:titleField.text detail:@"" money:moneyField.text finishBlock:^{
            @strongify(self);
            [self.orderListVm reload];
        }];
    }];
    
    [alert showEdit:self.navigationController title:@"记账" subTitle:@"" closeButtonTitle:@"取消" duration:0.0f];
}

- (UITableView *)list
{
    if (!_list) {
        _list = [[UITableView alloc] initWithFrame:ScreenBounds style:UITableViewStylePlain];
        [_list registerClass:HLOrderListTableViewCell.class forCellReuseIdentifier:kOrderListCell];
        _list.delegate = self;
        _list.dataSource = self;
    }
    return _list;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderListVm.orderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HLOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderListCell];
    [cell setOrder:self.orderListVm.orderArray[indexPath.row]];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.orderListVm.sumStr;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
