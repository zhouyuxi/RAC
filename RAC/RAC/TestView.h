//
//  TestView.h
//  RAC
//
//  Created by zhouyuxi on 2017/11/15.
//  Copyright © 2017年 zhouyuxi. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <ReactiveCocoa/ReactiveCocoa.h>//函数响应编程框架!!
#import "ReactiveObjC.h"

@protocol clickDelegate <NSObject>// 代理传值方法

- (void)clickMethod:(NSString *)str;

@end

@interface TestView : UIView
@property (nonatomic,strong) RACSubject *signal; // 信号
@property (nonatomic,weak) id<clickDelegate> mydelegate;
@property (weak, nonatomic) IBOutlet UIButton *redBtn;

- (IBAction)btnClick:(id)sender;
- (void)laile:(NSString *)str;



@end
