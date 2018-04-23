//
//  ZHDataBindViewModel.m
//  RAC的学习
//
//  Created by xyj on 2018/4/23.
//  Copyright © 2018年 xyj. All rights reserved.
//
 /*
 视图VM间的通信:
 1.源视图VM通过subject发出信号
 2.主线VM订阅subject信号,就可以接收到信号
 3.主线VM在把信号转交给目标视图VM
 */

#import "ZHDataBindViewModel.h"

@interface ZHDataBindViewModel()
@end
@implementation ZHDataBindViewModel
//1.懒加载子视图
-(ZHHotelTitleViewModel *)hotelTitleVM{
    if (_hotelTitleVM == nil) {
        _hotelTitleVM = [[ZHHotelTitleViewModel alloc] init];
        _hotelTitleVM.title = @"美团酒店-望京国际研发园店";
    }
    return _hotelTitleVM ;
}
-(ZHNameInputViewModel *)nameInputVM{
    if (_nameInputVM == nil) {
        _nameInputVM = [[ZHNameInputViewModel alloc] init];
    }
    return _nameInputVM ;
}
-(ZHPhoneInputViewModel *)PhoneInputVM{
    if (_PhoneInputVM == nil) {
        _PhoneInputVM = [[ZHPhoneInputViewModel alloc] init];
    }
    return _PhoneInputVM ;
}
-(ZHOrderDetailViewModel *)orderDetailVM{
    if (_orderDetailVM == nil) {
        _orderDetailVM = [[ZHOrderDetailViewModel alloc] init];
    }
    return _orderDetailVM ;
}
-(ZHHotelResultViewModel *)resultVM{
    if (_resultVM == nil) {
        _resultVM = [[ZHHotelResultViewModel alloc] init];
    }
    return _resultVM ;
}

//2.初始化
-(instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

-(void)setup{
    //1. 输入逻辑
  RAC(self.resultVM,resultStr) = [self combineHotelTitleViewModel:self.hotelTitleVM nameInputViewModel:self.nameInputVM phoneInputViewModel:self.PhoneInputVM];
    
    //2. 视图VM间的通信!!!!!!
    @weakify(self);
    //提示不能为nil
    [self.orderDetailVM.submitSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (!self.nameInputVM.inputText) {
            self.resultVM.resultStr = @"入住人不能为空!";
        }else if (!self.PhoneInputVM.inputText){
            self.resultVM.resultStr = @"手机号不能为空!";
        }else{
            //网络请求提交数据啦!!!!!
        }
    }];
    //清除输入
    [self.orderDetailVM.clearSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.nameInputVM.inputText = nil;
        self.PhoneInputVM.inputText = nil;
    }];
    
}

-(RACSignal *)combineHotelTitleViewModel:(ZHHotelTitleViewModel *)hotelTitleVM nameInputViewModel:(ZHNameInputViewModel *)nameInputVM phoneInputViewModel:(ZHPhoneInputViewModel *)phoneInputVM{
    //需要联合的信号
    NSArray *signals = @[hotelTitleVM.titleSignal,nameInputVM.inputChannel,phoneInputVM.inputChannel];
    //联合在聚合,返回聚合后的信号
    return [RACSignal combineLatest:signals reduce:^id _Nullable(NSString *title ,NSString *name, NSString *phone){
        return [NSString stringWithFormat:@"%@ 将入住 %@\n联系电话:%@",name?:@"",title,phone?:@""];
    }];
}

@end
