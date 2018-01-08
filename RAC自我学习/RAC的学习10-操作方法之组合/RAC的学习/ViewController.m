//
//  ViewController.m
//  RAC的学习
//
//  Created by xyj on 2017/12/25.
//  Copyright © 2017年 xyj. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACReturnSignal.h>
@interface ViewController ()
@property (nonatomic,weak) UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

// 监听文本框的内容改变，把结构重新映射成一个新值.



@implementation ViewController
-(void)viewDidLoad{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    textField.backgroundColor = [UIColor redColor];
    [self.view addSubview:textField];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(100, 300, 200, 30);
    [self.view addSubview: label];
    _textField = textField;
    
    [self test5];
}
/*
 combineLatest:将多个信号合并起来，并且拿到各个信号的最新的值,必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号。

 1.combineLatest:单独使用功能跟zipWith一样
 
 // 底层实现：
 // 1.当组合信号被订阅，内部会自动订阅signalA，signalB,必须两个信号都发出内容，才会被触发。
 // 2.并且把两个信号组合成元组发出。
 
  `reduce`聚合:用于信号发出的内容是元组，把信号发出元组的值聚合成一个值
 1. 常见用法:先组合再聚合
 //NSFastEnumeration:就是数组的意思
 combineLatest:(id<NSFastEnumeration>)signals reduce:(id (^)())reduceBlock
 2. reduce中的block简介:
   reduceblcok中的参数，有多少信号组合，reduceblcok就有多少参数，每个参数就是之前信号发出的内容
  reduceblcok的返回值：聚合信号之后的内容。
 // 底层实现:
 // 1.订阅聚合信号，每次有内容发出，就会执行reduceblcok，把信号内容转换成reduceblcok返回的值。

 */
- (void)test5 {
    
    
    //需求:当"手机号"与"密码"都有值是,"登录"使能,将三个控件分别拖到控制器属性中
    RACSignal *combineSignal = [RACSignal combineLatest:@[self.phoneTextField.rac_textSignal,self.passWordTextField.rac_textSignal] reduce:^id _Nullable(NSString *account , NSString *pwd){
        //NSString *account , NSString *pwd : 这些参数有组合信号发出的内容而定
        //block调用: 只要原信号发送内容就会调用,组合成一个新值
        NSLog(@"%@===%@",account,pwd);
        //聚合的值,就是组合信号的内容
        return @(account.length&&pwd.length);
    }];
    //订阅组合信号g
    //方法1:
    [combineSignal subscribeNext:^(id  _Nullable x) {
        self.loginBtn.enabled = [x boolValue];
    }];
    //方法2:
//    RAC(self.loginBtn,enabled) = combineSignal;
}
//把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元组，才会触发压缩流的next事件。
- (void)test4 {
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB =  [RACSubject subject];
    
    //当一个界面多个网络请求的时候,要等到所有请求都完成才能更新UI
    
    // 压缩信号A，信号B
    RACSignal *zipSignal = [signalA zipWith:signalB];
    
    [zipSignal subscribeNext:^(id x) {
        //x是一个元组,x中的排列顺序与组合顺序相同
        NSLog(@"%@",x);
    }];
    //仅仅A发送时不会触发的
    [signalA sendNext:@1];
    [signalB sendNext:@2];
}
/*
merge:把多个信号合并为一个信号，任何一个信号有新值的时候就会调用
 // 底层实现：
 // 1.合并信号被订阅的时候，就会遍历所有信号，并且发出这些信号。
 // 2.每发出一个信号，这个信号就会被订阅
 // 3.也就是合并信号一被订阅，就会订阅里面所有的信号。
 // 4.只要有一个信号被发出就会被监听。
 */
- (void)test3 {
    // merge:把多个信号合并成一个信号
    //当有多个网络请求时,哪个先请求,哪个先调用
    //创建多个信号
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@2];
        
        return nil;
    }];
    
    // 合并信号,任何一个信号发送数据，都能监听到.
    RACSignal *mergeSignal = [signalA merge:signalB];
    
    [mergeSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    

}
/*
 1. 作用: 用于连接两个信号，当第一个信号完成，才会连接then返回的信号。
 注意:使用then，之前信号的值会被忽略掉.
  底层实现：1、先过滤掉之前的信号发出的值。2.使用concat连接then返回的信号
 */
- (void)test2 {
    //1. 创建信号1
    RACSignal *signalA = [RACSubject createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //发送网络请求
        NSLog(@"网络请求1");
        //发送信号(将请求的数据发送出去)
        [subscriber sendNext:@"网络请求1的数据"];
        [subscriber sendCompleted];
        return nil;
    }];
    //2.创建信号B
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //发送网络请求
        NSLog(@"网络请求2");
        //发送信号(将请求的数据发送出去)
        [subscriber sendNext:@"网络请求2的数据"];
        [subscriber sendCompleted];
        return nil;
    }];
    [[signalA then:^RACSignal *{
        return signalB;
    }] subscribeNext:^(id x) {
        
        // 只能接收到第二个信号的值，也就是then返回信号的值
        NSLog(@"%@",x);
    }];

}

/*
 contact :
 1.作用: 按一定顺序按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号。
 
 */
- (void)test {
    //1. 创建信号1
    RACSignal *signalA = [RACSubject createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       //发送网络请求
        NSLog(@"网络请求1");
        //发送信号(将请求的数据发送出去)
        [subscriber sendNext:@"网络请求1的数据"];
        [subscriber sendCompleted];
        return nil;
    }];
    //2.创建信号B
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //发送网络请求
        NSLog(@"网络请求2");
        //发送信号(将请求的数据发送出去)
        [subscriber sendNext:@"网络请求2的数据"];
        [subscriber sendCompleted];
        return nil;
    }];
    //把signalA拼接到signalB后面,signalA发送完成,signalB才会被激活
    //注意：第一个信号必须发送完成，第二个信号才会被激活,即:第一个信号必须要调用 [subscriber sendCompleted];
    // 以后只需要面对拼接信号开发。
    // 订阅拼接的信号，不需要单独订阅signalA，signalB
    // 内部会自动订阅。
    //3. 创建组合信号
    RACSignal *contactSignal = [signalA concat:signalB];
    //4. 订阅信号
    [contactSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
}

@end
