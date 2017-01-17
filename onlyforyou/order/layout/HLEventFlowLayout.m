//
//  HLEventFlowLayout.m
//  onlyforyou
//
//  Created by honghao5 on 17/1/17.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import "HLEventFlowLayout.h"

@implementation HLEventFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake((ScreenBounds.size.width - 10) / 4.f - 10, (ScreenBounds.size.width - 10) / 4.f - 10);
        self.minimumLineSpacing = 10;
        self.minimumInteritemSpacing = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}

@end
