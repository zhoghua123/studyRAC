//
//  ViewController.m
//  RAC的学习
//
//  Created by xyj on 2017/12/25.
//  Copyright © 2017年 xyj. All rights reserved.
//

/*
 1.  常见的架构思想:
 MVC M:模型 V:视图 C:控制器
 MVVM M:模型 V:视图+控制器 VM:视图模型
 MVCS M:模型 V:视图 C:控制器 C:服务类
 VIPER V:视图 I:交互器 P:展示器 E:实体 R:路由
 2. MVVM介绍
 模型(M):保存视图数据。
 视图+控制器(V):展示内容 + 如何展示
 视图模型(VM):处理展示的业务逻辑，包括按钮的点击，数据的请求和解析等等。
 */
#import "ViewController.h"
//#import <ReactiveObjC/ReactiveObjC.h>
#import "RequestModel.h"
@interface ViewController ()
@property (nonatomic,strong) RequestModel *requestModel;

@end


/*
 步骤:
 1.控制器提供一个视图模型（requesViewModel），处理界面的业务逻辑
 2.VM提供一个命令，处理请求业务逻辑
 3.在创建命令的block中，会把请求包装成一个信号，等请求成功的时候，就会把数据传递出去。
 4.请求数据成功，应该把字典转换成模型，保存到视图模型中，控制器想用就直接从视图模型中获取。
 5.假设控制器想展示内容到tableView，直接让视图模型成为tableView的数据源，把所有的业务逻辑交给视图模型去做，这样控制器的代码就非常少了。

 */
// ReactiveCocoa + MVVM 实战一：登录界面
@implementation ViewController
-(RequestModel *)requestModel{
    if (_requestModel == nil) {
        _requestModel = [[RequestModel alloc] init];
    }
    return _requestModel ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    RACSignal *signal = [self.requestModel.requestCommand execute:nil];
    
    [signal subscribeNext:^(id  _Nullable x) {
    //模型数据
    //获取模型数据
        NSLog(@"%@",x);
    }];
   
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

@end
