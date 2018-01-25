//
//  PeopleViewCell.m
//  RAC的学习
//
//  Created by xyj on 2018/1/25.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "PeopleViewCell.h"
#import "PersonModel.h"
@interface PeopleViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;

@end
@implementation PeopleViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _adressLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 15;
}

//从写模型set方法
-(void)setModel:(PersonModel *)model{
    _model = model;
    _nameLabel.text = model.userNickName;
    _sexLabel.text = model.sex;
    _adressLabel.text = model.familyAdress;
}
@end
