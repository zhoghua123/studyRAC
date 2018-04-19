//
//  Book.m
//  RAC的学习
//
//  Created by xyj on 2018/1/8.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "Book.h"
#import "ZHBooklistCellViewModel.h"
@implementation Book
+(instancetype)bookWithDict:(NSDictionary *)dict{
    
    Book *book = [[self alloc] init];
    book.title = dict[@"title"];
    book.subtitle = dict[@"subtitle"];
    book.price = dict[@"price"];
    book.pubdate = dict[@"pubdate"];
    book.cellViewModel = [[ZHBooklistCellViewModel alloc] initWithModel:book];
    return book;
}
-(void)dealloc{
    NSLog(@"%s",__func__);
}
@end
