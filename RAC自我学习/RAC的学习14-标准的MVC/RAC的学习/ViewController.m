//
//  ViewController.m
//  RAC的学习
//
//  Created by xyj on 2017/12/25.
//  Copyright © 2017年 xyj. All rights reserved.
//

/*
 标准MVC 的特点:
 1. 控制器C:
    1. 控制器有一个数据源模型数组(当然有时也可以是单个模型)属性
    2. 控制器发送网络请求更新模型,然后刷新数据
 
 2. 视图View(cell):
    1.view有一个模型属性,通过这个模型来获取所要展示的数据(model的set方法重写)
    2.view的.h不暴露任何子控件属性,所有的展示逻辑全部放在.m内部
 3. 模型Model:
    1. 提供数据展示所需的属性
    2. 提供一个字典转模型的方法(当然也可以不提供,通过MJExtension)
    3. 添加辅助属性(当服务器的返回数据不能直接展示时,我们可以添加辅助属性,然后从写该属性的get方法,在get方法中处理成可以直接展示的属性)
 */
#import "ViewController.h"
#import "PersonModel.h"
#import "PeopleViewCell.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) UITableView *tableView;
//数据源
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation ViewController
-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //1.初始化UI
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView registerNib:[UINib nibWithNibName:@"PeopleViewCell" bundle:nil] forCellReuseIdentifier:@"PeopleViewCell"];
    //2. 网络请求
    [self requestAction];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PeopleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PeopleViewCell"];
    //只给cell传递模型,不暴露cell的其他属性
    cell.model = self.dataSource[indexPath.row];
    return cell;
}


#pragma mark - 网络请求
-(void)requestAction{
    //1.相当于网络请求
  NSString *filePath =  [[NSBundle mainBundle] pathForResource:@"data.plist" ofType:nil];
    NSMutableArray *data1 = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    //2.拿到数据: 字典数组转为模型数组
    for (NSDictionary *dic in data1) {
        PersonModel *model = [[PersonModel alloc] initWithDict:dic];
        [self.dataSource addObject:model];
    }
    //3. 刷新界面
    [self.tableView reloadData];
    NSLog(@"%@",data1);
}
@end
