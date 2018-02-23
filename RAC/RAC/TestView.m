//
//  TestView.m
//  RAC
//
//  Created by zhouyuxi on 2017/11/15.
//  Copyright © 2017年 zhouyuxi. All rights reserved.
//

#import "TestView.h"


@implementation TestView

-(RACSubject *)signal
{
    // 创建信号
    if(_signal == nil){
        
        _signal = [RACSubject subject];
    }
    return _signal;
}


- (IBAction)btnClick:(id)sender {
    // 发送信号，通知外面，发送消息
    [self.signal sendNext:self.backgroundColor];

//
    if ([_mydelegate respondsToSelector:@selector(clickMethod:)] ) {
        [_mydelegate clickMethod:@"😁"];
    }

    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"111" object:dataArray];
    [self laile:@"come here"];
}

- (IBAction)redBtn:(id)sender {

}

- (void)laile:(NSString *)str
{
    
//    NSLog(@"%@",str);
}


@end
