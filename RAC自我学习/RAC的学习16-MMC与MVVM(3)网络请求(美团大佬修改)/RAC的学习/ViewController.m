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
/*
 如何使用MVVM
 分析：
 1.之前界面的所有业务逻辑都交给控制器做处理
 2.在MVVM架构中把控制器的业务全部搬去VM模型，也就是每个控制器对应一个VM模型.
 3.VM特点
    1. 视图模型,处理界面上的所有业务逻辑,每一个控制器对应一个VM模型
    2. 最好不要包括视图V
    3. 模型都是继承自NSObject,命名都是以**ViewModel命名
 
 MVVM编程步骤
 1. 先创建VM模型,把整个界面的一些业务逻辑处理完
 2. 回到控制器去执行
 */

/*
 步骤:
 1.控制器提供一个视图模型（requesViewModel），处理界面的业务逻辑
 2.VM提供一个命令，处理请求业务逻辑
 3.在创建命令的block中，会把请求包装成一个信号，等请求成功的时候，就会把数据传递出去。
 4.请求数据成功，应该把字典转换成模型，保存到视图模型(VM)中，控制器想用就直接从视图模型(VM)中获取。
 5.假设控制器想展示内容到tableView，直接让视图模型(VM)成为tableView的数据源，把所有的业务逻辑交给视图模型(VM)去做，这样控制器的代码就非常少了。
 
 */
/*
 MVVM的特点:
 1. 控制器C:
    1. 控制器有一个视图模型(VM)属性,此时是将视图模型作为数据源
    2. 控制器通过VM执行发送数据请求命令
    3. 控制器中通过VM监听数据请求的过程
    4. 控制器中监听VM中数据源属性的改变,从而驱动(刷新)视图
 2. VM(RequestViewModel):
    1. 提供一个数据请求命令,用于执行数据请求
    2. 拥有一个数据源属性(把MVC控制器中的数据源搬到这里来)
    3. 数据处理,发送网络请求更新模型,搬到了这里
 3. View与MVC 一样仍然不变
 4. Model与MVC 一样仍然不变
 
 注意:
 1. 不应该在VM中出现View
 2. 用RAC实现数据驱动视图的思想
 */
#import "ViewController.h"
#import "RequestViewModel.h"
#import "Book.h"
#import "BookViewCell.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) RequestViewModel *viewModel;
@property (nonatomic,weak) UITableView *tableView;
@end

@implementation ViewController
//此时是将视图模型作为数据源
-(RequestViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[RequestViewModel alloc] init];
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
    [RACObserve(self.viewModel, models) subscribeNext:^(id  _Nullable x) {
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
    return self.viewModel.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookViewCell"];
    cell.bookModel = self.viewModel.models[indexPath.row];
    return cell;
}


@end
