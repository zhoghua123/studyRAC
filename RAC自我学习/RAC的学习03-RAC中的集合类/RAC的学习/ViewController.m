//
//  ViewController.m
//  RAC的学习
//
//  Created by xyj on 2017/12/25.
//  Copyright © 2017年 xyj. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface ViewController ()

@end

@implementation ViewController
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
 /*
  RACSequence:
  1.RAC中的集合媒介类
  2.作用:起到中间的媒介作用,用于代替NSArray,NSDictionary,可以使用它来快速遍历数组和字典。
  2.1 把集合(NSArray,NSDictionary,RACTuple等)转换成RACSequence类: 集合.rac_sequence
  2.2 把RACSequence类转换RACSignal信号类:集合.rac_sequence.signal
  2.3 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。: [集合.rac_sequence.signal subscribeNext:^(id x) {
  
  NSLog(@"%@",x);
  }];
  */
   //遍历数组
    NSArray *array = @[@"124",@"22",@"44"];
    //1. 把数组转换成集合RACSequence array.rac_sequence
    RACSequence *sequence = array.rac_sequence;
    //2. 把集合RACSequence转换RACSignal信号类,array.rac_sequence.signal
    RACSignal *signal = sequence.signal;
    //3. 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    //以上3步整合成一步
    [array.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //遍历字典
    //遍历出来的键值对会包装成RACTuple(元组对象)
    NSDictionary *dic = @{
                          @"name" : @"xiaoli",
                          @"year" : @20,
                          @"sex"  : @"男"
                          };
    //遍历
    [dic.rac_sequence.signal subscribeNext:^(RACTuple * x) {
        //打印x类型为RACTwoTuple(只放2个值,RACTuple的子类),因此在这里改变id类型为RACTuple类型
        NSLog(@"%@",x);
        //解析字典
        //方法1:
        NSString *key = x[0];
        NSString *value = x[1];
        NSLog(@"key==%@=value==%@",key,value);
        //方法2:
        //RACTupleUnpack:宏,解包元组，会把元组的值，按顺序给参数里面的变量赋值."="右边放需解析的元组.
        RACTupleUnpack(NSString *key2,NSString *value2) = x;
        NSLog(@"key2==%@=value2==%@",key2,value2);
    }];
    
    //字典转模型
    // 3.字典转模型
    // 3.1 OC写法
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *items = [NSMutableArray array];
    _items = items;
    for (NSDictionary *dict in dictArr) {
        FlagItem *item = [FlagItem flagWithDict:dict];
        [items addObject:item];
    }
    
    // 3.2 RAC写法
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *flags = [NSMutableArray array];
    
    _flags = flags;
    
    // rac_sequence注意点：调用subscribeNext，并不会马上执行nextBlock，而是会等一会。
    [dictArr.rac_sequence.signal subscribeNext:^(id x) {
        // 运用RAC遍历字典，x：字典
        
        FlagItem *item = [FlagItem flagWithDict:x];
        
        [flags addObject:item];
        
    }];
    
    NSLog(@"%@",  NSStringFromCGRect([UIScreen mainScreen].bounds));
    
    
    // 3.3 RAC高级写法:
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
    // map:映射的意思，目的：把原始值value映射成一个新值
    // array: 把集合转换成数组
    // 底层实现：当信号被订阅，会遍历集合中的原始值，映射成新值，并且保存到新的数组里。
    NSArray *flags = [[dictArr.rac_sequence map:^id(id value) {
        
        return [FlagItem flagWithDict:value];
        
    }] array];

}
- (void)test {
    /*
     //RACTuple:
     1. 元组类,类似NSArray,用来包装值.
     2. 使用方法跟NSArray基本一样
     */
    /*******基本用法*********/
    //1. 创建
    RACTuple *tuple = [RACTuple tupleWithObjectsFromArray:@[@"123",@"234",@"345"]];
    //    [RACTuple tupleWithObjects:@"123",@"444", nil]
    //2. 取值
    NSString *str = tuple[0];
    //    [tuple objectAtIndex:0];
    //3. 添加(这里是返回一个新值(RACTuple),并不是可变数据的特性)
    RACTuple *tuple2 = [tuple tupleByAddingObject:@"555"];
    NSLog(@"%@",str);
    //4.RAC特有用法:遍历
    [tuple.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"======%@",x);
    }];
    
    //5.其他用法
    //5.1 获取数量
    NSLog(@"%zd",tuple.count);
    //5.2 获取首尾
    NSLog(@"%@===%@",tuple.first,tuple.last);
    //5.3 RACTuple转换成数组类型
    NSArray *array = [tuple allObjects];
    NSLog(@"%@",array);
    NSLog(@"tuple2===%@",[tuple2 allObjects]);
}
@end
