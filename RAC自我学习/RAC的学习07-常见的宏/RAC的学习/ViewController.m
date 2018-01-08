//
//  ViewController.m
//  RAC的学习
//
//  Created by xyj on 2017/12/25.
//  Copyright © 2017年 xyj. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "TwoViewController.h"
@interface ViewController ()
@end

@implementation ViewController
-(void)viewDidLoad{
    // 把参数中的数据包装成元组
    RACTuplePack(@10,@12);
    // 把参数中的数据包装成元组
    RACTuple *tuple = RACTuplePack(@"xmg",@20);
    // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
    // name = @"xmg" age = @20
    RACTupleUnpack(NSString *name,NSNumber *age) = tuple;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    self.view.center = CGPointMake(100, 100);
    [self.navigationController pushViewController:[TwoViewController new] animated:YES];
}
- (void)test2 {
    [RACObserve(self.view, center) subscribeNext:^(id  _Nullable x) {
        NSLog(@"属性改变%@",x);
    }];
}
- (void)test1 {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    textField.backgroundColor = [UIColor redColor];
    [self.view addSubview:textField];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(100, 300, 200, 30);
    [self.view addSubview: label];
    //方法1:
    [textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        label.text = x;
    }];
    //方法2:
    RAC(label,text) = textField.rac_textSignal;
    
}
@end
