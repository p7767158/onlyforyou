//
//  HLEventSelectViewController.m
//  onlyforyou
//
//  Created by honghao5 on 17/1/11.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import "HLEventSelectViewController.h"
#import "HLEventFlowLayout.h"
#import "HLEventCollectionViewCell.h"
#import "HLEvent.h"
#import "HLEventEditViewController.h"

@interface HLEventSelectViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *events;

@end

@implementation HLEventSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"干啥了";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    @weakify(self);
    [[RACObserve(self, events) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.events = [HLEvent events];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)edit:(id)sender
{
    [self.navigationController pushViewController:[[HLEventEditViewController alloc] init] animated:YES];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:ScreenBounds collectionViewLayout:[[HLEventFlowLayout alloc] init]];
        _collectionView.backgroundColor = [HLColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:HLEventCollectionViewCell.class forCellWithReuseIdentifier:kEventCollectionCell];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.events.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HLEventCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kEventCollectionCell forIndexPath:indexPath];
    [cell setEvent:self.events[indexPath.item]];
    return cell;
}

@end
