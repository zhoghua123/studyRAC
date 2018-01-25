//
//  PersonModel.h
//  RAC的学习
//
//  Created by xyj on 2018/1/25.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject
@property (nonatomic,copy) NSString *userNickName;
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *village;
@property (nonatomic,copy) NSString *town;
@property (nonatomic,copy) NSString *userSex;

//辅助属性(因此有些逻辑不一定非要放到控制器中)
@property (nonatomic,copy) NSString *familyAdress;
@property (nonatomic,copy) NSString *sex;

-(instancetype)initWithDict:(NSDictionary *)dic;
@end
