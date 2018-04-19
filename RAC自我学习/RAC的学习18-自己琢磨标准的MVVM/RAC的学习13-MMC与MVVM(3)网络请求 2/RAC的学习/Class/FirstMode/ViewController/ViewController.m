//
//  ViewController.m
//  RAC的学习
//
//  Created by xyj on 2017/12/25.
//  Copyright © 2017年 xyj. All rights reserved.
//
/*
 在这个控制器中:
 ZHTableViewViewModel:
 主线VM,有网络请求属性
 ZHBookListViewModel就是主消息VM,继承自ZHTableViewViewModel
 ZHBooklistCellViewModel是视图VM,由主线VM来更新,继承自ZHBaseViewModel
 
 */


#import "ViewController.h"
#import "ZHBookListViewModel.h"
#import "ZHBooklistCellViewModel.h"
#import "BookViewCell.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) ZHBookListViewModel *viewModel;
@property (nonatomic,weak) UITableView *tableView;
@end

@implementation ViewController
//此时是将视图模型作为数据源
-(ZHBookListViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[ZHBookListViewModel alloc] init];
    }
    return _viewModel ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.创建tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView registerNib:[UINib nibWithNibName:@"BookViewCell" bundle:nil] forCellReuseIdentifier:@"BookViewCell"];
    //1.执行数据请求命令
    [self.viewModel.requestCommand execute:@"iOS"];
    
    // Zhuo：加了个例子，3秒后再次发送请求刷新列表
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.viewModel.requestCommand execute:@"Android"];
    });
    
    //2.监听命令执行过程,弹框提示
    //skip1的原因是,程序已启动就回调用一次
    [[self.viewModel.requestCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue] == YES) {
            //正在执行
            NSLog(@"请求中");
            //弹框提示正在登录
        }else{
            //执行完成,隐藏弹框
            NSLog(@"请求完成");
        }
    } error:^(NSError * _Nullable error) {
        NSLog(@"请求失败");
    }];
    
    //3.监听数据的改变,驱动视图(数据驱动视图的思想)
    // Zhuo: 注意加上weakify/strongify，否则有内存泄漏
    @weakify(self)
    [RACObserve(self.viewModel, dataSource) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
         [self.tableView reloadData];
    }];
    
}

#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //此时只是多了一个VM
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookViewCell"];
    cell.cellViewModel = self.viewModel.dataSource[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.viewModel.requestCommand execute:@"C"];
}

@end
