//
//  PersonModel.m
//  RAC的学习
//
//  Created by xyj on 2018/1/25.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "PersonModel.h"

@implementation PersonModel
-(instancetype)initWithDict:(NSDictionary *)dic{
    if (self = [super init]) {
        _userNickName = dic[@"userNickName"];
        _province = dic[@"province"];
        _city = dic[@"city"];
        _village = dic[@"village"];
        _town = dic[@"town"];
        _userSex = dic[@"userSex"];
    }
    return self;
}
-(NSString *)sex{
    _sex = [_userSex boolValue] ?  @"女": @"男";
    return _sex;
}
-(NSString *)familyAdress{
    _familyAdress = [NSString stringWithFormat:@"%@%@%@%@",_province,_city,_village,_town];
    return _familyAdress;
}
@end
