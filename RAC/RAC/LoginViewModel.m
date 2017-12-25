//
//  LoginViewModel.m
//  RAC
//
//  Created by zhouyuxi on 2017/11/23.
//  Copyright © 2017年 zhouyuxi. All rights reserved.
//

#import "LoginViewModel.h"
#import "AppHttpTool.h"
#import "MBProgressHUD.h"
#import "RACReturnSignal.h"

@interface LoginViewModel()

@end


@implementation LoginViewModel

- (instancetype)init
{
    if (self == [super init]) {
//     [self buildData];
        [self bindData];
    }
    return  self;
}

- (void)bindData
{
    _combineSignal = [RACSignal combineLatest:@[RACObserve(self, account),RACObserve(self, pwd)] reduce:^id _Nullable(NSString *account , NSString *pwd){
        return @(account.length && pwd.length);
    }];
    
    // 创建源信号
    if (self.subjectSource == nil) {
        self.subjectSource = [RACSubject subject];
    }
    
    // 绑定一个信号
    RACSignal *bindSignal = [[_subjectSource bind:^RACSignalBindBlock _Nonnull{
        return  ^RACSignal * (id _Nullable value, BOOL *stop){
            //block调用：只要源信号发送数据，就会调用bindBlock
            //value:源信号发送的内容
            NSLog(@"%@",value);
            return [RACReturnSignal return:@"123"];
            // 返回信号不能为nil，这里需要返回一个RACReturnSignal （return 模型）
//            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//                [self getData:subscriber input:value];
//
//                return  nil;
//            }];
        };
    }] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        
        NSLog(@"%@",value);
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [self getData:subscriber input:value];

                return  nil;
            }];
    }];
    
    [bindSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"接受到的数据——————-%@",x);
    }];
}


// 命令
- (void)buildData
{
    _combineSignal = [RACSignal combineLatest:@[RACObserve(self, account),RACObserve(self, pwd)] reduce:^id _Nullable(NSString *account , NSString *pwd){
        return @(account.length && pwd.length);
    }];
    
    //创建命令
    _commond = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        // 处理密码加密等事件
        NSLog(@"准备发送数据--%@",input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [self getData:subscriber input:input];
            
            return  nil;
        }];
    }];
    
    //获取命令中的信号源，订阅
    [_commond.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅的信号---%@",x);
    }];
    
    [[_commond.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) { // 跳到1
        if ([x boolValue]) {
            NSLog(@"显示菊花");
            [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
        }else{
            NSLog(@"隐藏菊花");
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
        }
    }];
}

- (void)getData:(id<RACSubscriber>)subscriber input:(id)input
{
    NSString *url =@"https://gateway.qschou.com/v3.0.0/passport/sms/login";
    NSMutableDictionary *dict  = [NSMutableDictionary dictionary];
    [dict setObject:@"" forKey:@"bind_phone_flag"];
    [dict setObject:@"86" forKey:@"country_code"];
    [dict setObject:@"15801595906" forKey:@"phone"];
    [dict setObject:@"ios_qsc" forKey:@"platform"];
    [dict setObject:@"0186" forKey:@"sms_code"];
    
    [AppHttpTool post:url parameters:dict httpToolSuccess:^(id json) {
        NSLog(@"json ---%@",json);
        [subscriber sendNext:json];
        [subscriber sendCompleted];
    } failure:^(NSError *error) {
        NSLog(@"");
     
    }];
}


- (void)setDataWithValue:(NSString *)value jsonBlock:(void(^)(id json))block
{
    NSString *url =@"https://gateway.qschou.com/v3.0.0/passport/sms/login";
    NSMutableDictionary *dict  = [NSMutableDictionary dictionary];
    [dict setObject:@"" forKey:@"bind_phone_flag"];
    [dict setObject:@"86" forKey:@"country_code"];
    [dict setObject:@"15801595906" forKey:@"phone"];
    [dict setObject:@"ios_qsc" forKey:@"platform"];
    [dict setObject:@"3810" forKey:@"sms_code"];
    [AppHttpTool post:url parameters:dict httpToolSuccess:^(id json) {
        NSLog(@"json ---%@",json);
        block(json);
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}


@end
