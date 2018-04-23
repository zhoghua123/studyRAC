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
#import "ZHDataBindViewModel.h"
@interface ZHDataBindController ()
@property (nonatomic,strong) ZHDataBindViewModel *bindVM;
@end

@implementation ZHDataBindController
-(ZHDataBindViewModel *)bindVM{
    if (_bindVM == nil) {
        _bindVM = [[ZHDataBindViewModel alloc] init];
    }
    return _bindVM ;
}
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
    switch (indexPath.row) {
        case 0:
        {
            ZHHotelTitleCell *cell0 =  [tableView dequeueReusableCellWithIdentifier:@"ZHHotelTitleCell"];
            [cell0 bindViewWithViewModel:self.bindVM.hotelTitleVM];
            return cell0;
        }
            break;
        case 1:
        {
            ZHLabelAndTextFieldCell *cell1 =     [tableView dequeueReusableCellWithIdentifier:@"ZHLabelAndTextFieldCell"];
            cell1.titleLabel.text = @"入住人";
            [cell1 bindViewWithViewModel:self.bindVM.nameInputVM];
            return cell1;
        }
            break;
        case 2:
        {
            ZHLabelAndTextFieldCell *cell2 =     [tableView dequeueReusableCellWithIdentifier:@"ZHLabelAndTextFieldCell"];
            cell2.titleLabel.text = @"手机号";
            [cell2 bindViewWithViewModel:self.bindVM.PhoneInputVM];
            return cell2;
        }
            break;
        case 3:
        {
            ZHHotelResultCell *cell3 =   [tableView dequeueReusableCellWithIdentifier:@"ZHHotelResultCell"];
            [cell3 bindViewWithViewModel:self.bindVM.resultVM];
            return cell3;
        }
            break;
        case 4:
        {
            ZHHotelBtnsCell *cell4 =   [tableView dequeueReusableCellWithIdentifier:@"ZHHotelBtnsCell"];
            [cell4 bindViewWithViewModel:self.bindVM.orderDetailVM];
            return cell4;
        }
            break;
        default:
            break;
    }
    return nil;
}
@end
