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
#import "HLEventCollectionHeaderView.h"
#import "HLEvent.h"
#import "HLEventEditViewController.h"

static const int kEvent = 0;
static const int kHideEvent = 1;

@interface HLEventSelectViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *events;
@property (nonatomic, strong) NSMutableArray *hideEvents;
@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, strong) UIView *movingView;
@property (nonatomic, strong) NSIndexPath *originIndexPath;

@end

@implementation HLEventSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.events = [[HLEvent events] mutableCopy];
    self.hideEvents = [[HLEvent hideEvents] mutableCopy];
    
    self.navigationItem.title = @"干啥了";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    @weakify(self);
    [[RACObserve(self, events) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
    
    [[RACObserve(self, isEdit) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        @strongify(self);
        
        if ([x boolValue] == NO) {
            [self.events enumerateObjectsUsingBlock:^(HLEvent *  _Nonnull event, NSUInteger idx, BOOL * _Nonnull stop) {
                [event setRank:idx];
                [event setHide:NO];
            }];
            [self.hideEvents enumerateObjectsUsingBlock:^(HLEvent *  _Nonnull event, NSUInteger idx, BOOL * _Nonnull stop) {
                [event setRank:idx];
                [event setHide:YES];
            }];
        }
        
        [self.collectionView reloadData];
        
        self.navigationItem.rightBarButtonItem.title = [x boolValue] == YES ? @"确定" : @"编辑";
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)edit:(id)sender
{
    self.isEdit = !self.isEdit;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:ScreenBounds collectionViewLayout:[[HLEventFlowLayout alloc] init]];
        _collectionView.backgroundColor = [HLColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:HLEventCollectionViewCell.class forCellWithReuseIdentifier:kEventCollectionCell];
        [_collectionView registerClass:HLEventCollectionHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHLEventCollectionHeaderView];
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [_collectionView addGestureRecognizer:longPressGesture];
    }
    return _collectionView;
}

- (void)longPress:(UILongPressGestureRecognizer *)longPressGesture
{
    if (!self.isEdit) {
        return;
    }
    
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        CGPoint locationPoint = [longPressGesture locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:locationPoint];
        self.originIndexPath = indexPath;
        if (indexPath.section == 0) {
            HLEventCollectionViewCell *cell = (HLEventCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            self.movingView = [self snapshotViewFromOriginView:cell];
            [self.collectionView addSubview:self.movingView];
            cell.alpha = 0.f;
            
            [UIView animateWithDuration:0.2 animations:^{
                CGAffineTransform transform = CGAffineTransformMakeScale(1.1, 1.1);
                self.movingView.transform = transform;
                self.movingView.center = locationPoint;
            }];
        }
    }
    
    if (longPressGesture.state == UIGestureRecognizerStateChanged) {
        self.movingView.center = [longPressGesture locationInView:self.collectionView];
        CGPoint locationPoint = [longPressGesture locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:locationPoint];
        if (indexPath.section == 0 && indexPath.item > 0) {
            [self.collectionView moveItemAtIndexPath:self.originIndexPath toIndexPath:indexPath];
            [self.events exchangeObjectAtIndex:self.originIndexPath.item withObjectAtIndex:indexPath.item];
            self.originIndexPath = indexPath;
            [self.collectionView cellForItemAtIndexPath:indexPath].alpha = 0.f;
        }
    }
    
    if (longPressGesture.state == UIGestureRecognizerStateEnded) {
        HLEventCollectionViewCell *cell = (HLEventCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.originIndexPath];
        [UIView animateWithDuration:0.2 animations:^{
            self.movingView.transform = CGAffineTransformIdentity;
            self.movingView.center = cell.center;
        } completion:^(BOOL finished) {
            cell.alpha = 1.f;
            [self.movingView removeFromSuperview];
            _movingView = nil;
        }];
    }
}

- (UIImageView *)snapshotViewFromOriginView:(UIView *)originView
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(originView.frame.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(originView.frame.size);
    }
    [originView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:originView.frame];
    imageView.image = image;
    
    return imageView;
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.isEdit ? 2 : 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == kEvent) {
        return self.events.count;
    } else {
        return self.hideEvents.count;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        HLEventCollectionHeaderView *headerView = (HLEventCollectionHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHLEventCollectionHeaderView forIndexPath:indexPath];
        if (indexPath.section == kEvent) {
            [headerView setTitle:@"已选事件"];
        } else {
            [headerView setTitle:@"隐藏事件"];
        }
        
        if (!self.isEdit) {
            [headerView setTitle:@""];
        }
        return headerView;
    }
    
    return nil;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HLEventCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kEventCollectionCell forIndexPath:indexPath];
    
    if (indexPath.section == kEvent) {
        [cell setEvent:self.events[indexPath.item]];
    } else {
        [cell setEvent:self.hideEvents[indexPath.item]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isEdit) {
        return;
    }
    
    HLEvent *event;
    if (indexPath.section == kEvent) {
        event = self.events[indexPath.item];
        [self.events removeObject:event];
        [self.hideEvents addObject:event];
        
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForItem:self.hideEvents.count - 1 inSection:kHideEvent]];
    } else {
        event = self.hideEvents[indexPath.item];
        [self.hideEvents removeObject:event];
        [self.events addObject:event];
        
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForItem:self.events.count - 1 inSection:kEvent]];
    }
}

@end
