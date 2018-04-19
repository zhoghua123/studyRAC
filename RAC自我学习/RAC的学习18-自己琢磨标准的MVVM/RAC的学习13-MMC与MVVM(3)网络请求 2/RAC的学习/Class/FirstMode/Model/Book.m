//
//  Book.m
//  RAC的学习
//
//  Created by xyj on 2018/1/8.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "Book.h"

@implementation Book
+(instancetype)bookWithDict:(NSDictionary *)dict{
    
    Book *book = [[self alloc] init];
    book.title = dict[@"title"];
    book.subtitle = dict[@"subtitle"];
    book.price = dict[@"price"];
    book.pubdate = dict[@"pubdate"];
    return book;
}
@end
