//
//  ZHDataBindViewModel.h
//  RAC的学习
//
//  Created by xyj on 2018/4/23.
//  Copyright © 2018年 xyj. All rights reserved.
//

/*
 主线VM下有几个视图VM
 */
#import "ZHBaseViewModel.h"
#import "ZHHotelTitleViewModel.h"
#import "ZHNameInputViewModel.h"
#import "ZHPhoneInputViewModel.h"
#import "ZHOrderDetailViewModel.h"
#import "ZHHotelResultViewModel.h"
@interface ZHDataBindViewModel : ZHBaseViewModel
@property (nonatomic,strong) ZHHotelTitleViewModel *hotelTitleVM;
@property (nonatomic,strong) ZHNameInputViewModel *nameInputVM;
@property (nonatomic,strong) ZHPhoneInputViewModel *PhoneInputVM;
@property (nonatomic,strong) ZHOrderDetailViewModel *orderDetailVM;
@property (nonatomic,strong) ZHHotelResultViewModel *resultVM;
@end
