//
//  ZHBookListViewModel.m
//  RAC的学习
//
//  Created by xyj on 2018/4/19.
//  Copyright © 2018年 xyj. All rights reserved.
//

/*
 该主线VM只会通信Model不会通信视图VM,视图VM在Model内部更新
 */
#import "ZHBookListViewModel.h"
#import "Book.h"
@interface ZHBookListViewModel()

@end

@implementation ZHBookListViewModel

- (instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    @weakify(self)
    //1.初始化网络请求命令(这里可以抽取到父类中!!!!)
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"======%@",input);
        @strongify(self)
        //2. 发送网络请求,并订阅请求发出的信号
        // Zhuo：网络层负责数据请求，以及返回数据封装成对象
        // VM 负责二次加工数据，比如要做筛选过滤操作，这儿单纯赋值触发UI刷新
        //返回网络请求的信号
        return [self.netRequest requestBookListWithURL:ZHURLSearchBook andParameter:@{@"q":input}];
    }];
    
    //3.订阅命令发出的信号(这里一定要在这里实现)
    [self.requestCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable responseObject) {
        //4.处理网络请求发出的信号数据
        @strongify(self)
        NSArray *dicAr = responseObject[@"books"];
        //4.1 Mj字典转模型数组
        NSArray *modelArray = [Book mj_objectArrayWithKeyValuesArray:dicAr];
        //4.2 将模型数组映射成VM数组
        NSArray *viewModelArray = [[modelArray.rac_sequence map:^id _Nullable(Book *  _Nullable value) {
            return value.cellViewModel;
        }] array];
        //5.赋值给数据源,VC监听触发UI界面
        self.dataSource = viewModelArray;
    }];
}

@end
