//
//  ZHOrderDetailViewModel.h
//  RAC的学习
//
//  Created by xyj on 2018/4/23.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ZHBaseViewModel.h"

@interface ZHOrderDetailViewModel : ZHBaseViewModel
//别的控件的话,就是对应的字符串,按钮的话对应的就是Command
//用于按钮的点击事件
@property (nonatomic,strong) RACCommand *clearCommand;
@property (nonatomic,strong) RACCommand *submitCommand;
//用于通信
@property (nonatomic,strong) RACSubject *clearSubject;
@property (nonatomic,strong) RACSubject *submitSubject;
@end
