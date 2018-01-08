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
@end

@implementation ViewController
-(void)viewDidLoad{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    textField.backgroundColor = [UIColor redColor];
    [self.view addSubview:textField];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(100, 300, 200, 30);
    [self.view addSubview: label];
    //需求: 假设想监听文本框的内容，并且在每次输出结果的时候，都在文本框的内容拼接一段文字“输出：”
    //方法1:
    [textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"输出:%@",x);
    }];
    // 方式二:在返回结果前，拼接，使用RAC中bind方法做处理。
   
    
    /*
     - (__kindof RACStream *)bind:(RACStreamBindBlock (^)(void))block;
     1.bind方法分析:
        1.参数:block(参数block返回值也是一个block)
            1.参数: 无
            2.返回值:RACStreamBindBlock
        2. 返回值:RACSignal
     2. RACStreamBindBlock:
        1. 定义:
        typedef RACSequence * _Nullable (^RACSequenceBindBlock)(ValueType _Nullable value, BOOL *stop);
        2. 参数:value,stop
            1.value:表示接收到信号的原始值，还没做处理
            2.*stop:用来控制绑定Block，如果*stop = yes,那么就会结束绑定。
        3. 返回值:RACSignal(信号)，做好处理，在通过这个信号返回出去，一般使用RACReturnSignal,需要手动导入头文件RACReturnSignal.h。
     注意:
     1.不同订阅者，保存不同的nextBlock，看源码的时候，一定要看清楚订阅者是哪个。
     2.这里需要手动导入#import <ReactiveCocoa/RACReturnSignal.h>，才能使用RACReturnSignal。
     bind方法使用步骤:
      1.传入一个返回值RACStreamBindBlock的block。
      2.描述一个RACStreamBindBlock类型的bindBlock作为block的返回值。
      3.描述一个返回结果的信号，作为bindBlock的返回值。
      4.在bindBlock中做信号结果的处理。
     体现的hook思想:
     任意一个信号,只要被绑定(bind),一旦发出数据信号,我们就能拿到这个信号进行处理,然后返回处理完的信号,当订阅拿到这个信号时,已经是改变后的信号
     */
    //1.绑定信号
    RACSignal *bindSignal = [textField.rac_textSignal bind:^RACSignalBindBlock _Nonnull{
        //当前block的调用时刻:绑定的信号(textField.rac_textSignal)被订阅时调用
        // block作用:表示绑定了一个信号.
        return ^RACSignal *(id value, BOOL *stop){
            // 什么时候调用block:只要源信号(textField.rac_textSignal)发送数据，就会来到这个block。
            // block作用:处理源信号的内容
            //value:源信号发送的内容
            // 做好处理，通过信号返回出去.
            value = [NSString stringWithFormat:@"输出:%@",value];
            //返回信号不能传nil,可以返回空信号[RACSignal empty];
            // return nil;
            //包装信号返回出去
            return [RACReturnSignal return:value];
        };
    }];
    //2.订阅绑定信号
    [bindSignal subscribeNext:^(id  _Nullable x) {
        //block调用时刻:当处理完信号发送数据的时候,就回调用这个block
         NSLog(@"%@",x);
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self test];
}
- (void)test {
    //1.创建信号
    RACSubject *sourceSignal = [RACSubject subject];
    //2. 绑定信号
    RACSignal *bindSignal = [sourceSignal bind:^RACSignalBindBlock _Nonnull{
        
        return ^RACSignal *(id value, BOOL *stop){
            
            value = [NSString stringWithFormat:@"在这里处理源信号:%@",value];
            
            return [RACReturnSignal return:value];
        };
    }];
    //3.订阅绑定信号
    [bindSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    //4. 发送数据
    [sourceSignal sendNext:@"123"];
}
/*
 1.源信号的订阅再内部,发送在外部
 2. 绑定信号的订阅再外部,发送在内部

 底层实现:
 1. 源信号调用bind,会返回重新创建(create)的一个绑定信号RACSignal(bindsignal)。
 2. 当绑定信号(bindsignal)被订阅,就会调用绑定信号中的didSubscribe
    1. 调用bind:传入的block,返回一个bindingBlock(RACSignalBindBlock)。
    2. 内部订阅外部的源信号,nextBlock
 3.当源信号有内容发出(发送信号)，调用bind内部的订阅nextBlock
    1. 调用bindingBlock,外部block实现中进行处理,并返回处理后的信号(RACReturnSignal)signal
    2. 调用内部定义的addSignal这个block,将returnsignal传入
        1. 订阅returnsignal,这个returnsignal是RACReturnSignal
             1. 内部会创建一个订阅者subscriber,保存nextblock
             2. 调用RACReturnSignal类的 :[self subscribe:o]
             3. 注意:是RACReturnSignal类的!!!,该方法内部会主动使用该订阅者发送信号,调用外部的nextblock
        3. nextblock内部调用:[subscriber sendNext:x];
        4. 注意:这个subscriber是bindsignal的订阅者
 4. 调用外部订阅bindSignal的nextblock,拿到改变后的值
 
 
 
 
 方法简化如下:
 - (RACSignal *)bind:(RACSignalBindBlock (^)(void))block {
 
    //定义addSignal一个block
     void (^addSignal)(RACSignal *) = ^(RACSignal *signal) {
 
        //7. 订阅returnsignal
        //这个signal是RACReturnSignal,调用subscribeNext:
            1. 内部会创建一个订阅者subscriber,保存nextblock
            2. 调用RACReturnSignal类的 :[self subscribe:o]
            3. 注意:是RACReturnSignal类的!!!,该方法内部会主动使用该订阅者发送信号,调用外部的nextblock
             - (RACDisposable *)subscribe:(id<RACSubscriber>)subscriber {
             return [RACScheduler.subscriptionScheduler schedule:^{
             [subscriber sendNext:self.value];
             [subscriber sendCompleted];
             }];
             }
 
 
 
 
        RACDisposable *disposable = [signal subscribeNext:^(id x) {
 
        //8. 发送信号bindsignal,将处理数据传出去
        //9. 调用外部bindsignal的nextblock
        //这个subscriber是bindsignal的订阅者
 
        [subscriber sendNext:x];
 
     } error:^(NSError *error) {
     } completed:^{
     }];
    };
 
   // 1.创建bindsignal
    return [[RACSignal createSignal:^(id<RACSubscriber> subscriber) {
 
            //2.调用外部传进的block,返回RACSignalBindBlock
            RACSignalBindBlock bindingBlock = block();
 
            //3.内部订阅源信号
            RACDisposable *bindingDisposable = [self subscribeNext:^(id x) {
 
                    //4. 外部源信号发送数据,来到这里
                    // 5. 调用外部的bindingBlock,获得(处理后的信号)returnsignal
                    BOOL stop = NO;
                    id signal = bindingBlock(x, &stop);
 
                    //6.调用自定义的addSignalblock
                    if (signal != nil) addSignal(signal);
 
                    } error:^(NSError *error) {
                    } completed:^{
                }];
            }
            return compoundDisposable;
            }]];
}

 */

@end
