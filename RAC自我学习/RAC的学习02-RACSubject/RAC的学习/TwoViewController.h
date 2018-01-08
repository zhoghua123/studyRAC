//
//  TwoViewController.h
//  RAC的学习
//
//  Created by xyj on 2017/12/26.
//  Copyright © 2017年 xyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
@interface TwoViewController : UIViewController
@property (nonatomic, strong) RACSubject *delegateSignal;
@end
