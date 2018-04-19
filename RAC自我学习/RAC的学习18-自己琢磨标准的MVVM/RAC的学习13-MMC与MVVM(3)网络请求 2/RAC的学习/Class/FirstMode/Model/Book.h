//
//  Book.h
//  RAC的学习
//
//  Created by xyj on 2018/1/8.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *pubdate;
//辅助属性
@property (nonatomic,copy) NSString *priceAndPubdate;
+(instancetype)bookWithDict:(NSDictionary *)dict;
@end
