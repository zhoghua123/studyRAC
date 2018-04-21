//
//  ZHDataBindController.m
//  RAC的学习
//
//  Created by xyj on 2018/4/20.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ZHDataBindController.h"
#import "ZHHotelBtnsCell.h"
#import "ZHHotelTitleCell.h"
#import "ZHHotelResultCell.h"
#import "ZHLabelAndTextFieldCell.h"
@interface ZHDataBindController ()

@end

@implementation ZHDataBindController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZHHotelBtnsCell" bundle:nil] forCellReuseIdentifier:@"ZHHotelBtnsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZHHotelTitleCell" bundle:nil] forCellReuseIdentifier:@"ZHHotelTitleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZHHotelResultCell" bundle:nil] forCellReuseIdentifier:@"ZHHotelResultCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZHLabelAndTextFieldCell" bundle:nil] forCellReuseIdentifier:@"ZHLabelAndTextFieldCell"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        return 80;
    }else if (indexPath.row == 4){
        return 200;
    }else{
        return 60;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
      ZHHotelTitleCell *cell3 =   [tableView dequeueReusableCellWithIdentifier:@"ZHHotelTitleCell"];
        return cell3;
    }else if (indexPath.row == 4){
      ZHHotelBtnsCell *cell4 =   [tableView dequeueReusableCellWithIdentifier:@"ZHHotelBtnsCell"];
        return cell4;
    }else if (indexPath.row == 0){
     ZHHotelTitleCell *cell0 =  [tableView dequeueReusableCellWithIdentifier:@"ZHHotelTitleCell"];
        return cell0;
    }else{
     ZHLabelAndTextFieldCell *cell12 =     [tableView dequeueReusableCellWithIdentifier:@"ZHLabelAndTextFieldCell"];
        return cell12;
    }
}
@end
