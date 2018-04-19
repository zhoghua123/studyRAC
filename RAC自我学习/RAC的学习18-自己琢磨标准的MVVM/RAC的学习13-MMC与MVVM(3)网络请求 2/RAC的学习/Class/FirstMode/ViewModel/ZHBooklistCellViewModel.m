//
//  ZHBooklistCellViewModel.m
//  RAC的学习
//
//  Created by xyj on 2018/4/19.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ZHBooklistCellViewModel.h"
#import "Book.h"
@implementation ZHBooklistCellViewModel
-(instancetype)initWithModel:(ZHBaseModel *)model{
    if (self = [super init]) {
        Book *book = (Book *)model;
        self.title = book.title;
        self.subtitle = book.subtitle;
        self.priceAndPubdate  =  [NSString stringWithFormat:@"%@/%@",book.price,book.pubdate];
    }
    return self;
}
@end
