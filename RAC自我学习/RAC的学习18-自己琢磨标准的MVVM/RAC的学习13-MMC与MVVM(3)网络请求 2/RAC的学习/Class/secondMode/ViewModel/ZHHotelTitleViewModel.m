//
//  ZHHotelTitleViewModel.m
//  RAC的学习
//
//  Created by xyj on 2018/4/20.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ZHHotelTitleViewModel.h"

@implementation ZHHotelTitleViewModel
-(instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}
-(void)setup{
    _titleSignal = RACObserve(self, title);
}
@end
