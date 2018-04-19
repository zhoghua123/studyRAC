//
//  ZHBooklistCellViewModel.h
//  RAC的学习
//
//  Created by xyj on 2018/4/19.
//  Copyright © 2018年 xyj. All rights reserved.
//

/*
 用于直接绑定视图的属性
 */
#import "ZHBaseViewModel.h"

@interface ZHBooklistCellViewModel : ZHBaseViewModel
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,copy) NSString *priceAndPubdate;
@end
