//
//  ZHBaseViewModelProtocol.h
//  RAC的学习
//
//  Created by xyj on 2018/4/19.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import <Foundation/Foundation.h>
//声明一个协议
@protocol ZHBaseViewModelProtocol;
@class ZHBaseModel;
//定义一个协议
@protocol ZHBaseViewModelProtocol <NSObject>
@optional
- (instancetype)initWithModel:(ZHBaseModel *)model;
@end

