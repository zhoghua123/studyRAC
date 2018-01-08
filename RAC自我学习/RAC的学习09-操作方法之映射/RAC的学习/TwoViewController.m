//
//  TwoViewController.m
//  RAC的学习
//
//  Created by xyj on 2018/1/3.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "TwoViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface TwoViewController ()
@property (nonatomic,strong)  RACSignal *signal ;
@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        NSLog(@"%@",self);
        return nil;
    }];
    self.signal = signal;
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}
@end
