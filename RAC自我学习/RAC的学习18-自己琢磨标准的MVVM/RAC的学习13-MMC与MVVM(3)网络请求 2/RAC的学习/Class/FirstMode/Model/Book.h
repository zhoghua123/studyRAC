//
//  Book.h
//  RAC的学习
//
//  Created by xyj on 2018/1/8.
//  Copyright © 2018年 xyj. All rights reserved.
//
/*
 Model中有一个视图VM,Model更新视图VM
 */
#import <Foundation/Foundation.h>
#import "ZHBaseModel.h"
@class ZHBooklistCellViewModel;
@interface Book : ZHBaseModel
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *pubdate;
+(instancetype)bookWithDict:(NSDictionary *)dict;
@property (nonatomic,strong) ZHBooklistCellViewModel *cellViewModel;
@end
