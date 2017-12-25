//
//  ModelController.m
//  RAC
//
//  Created by zhouyuxi on 2017/11/21.
//  Copyright © 2017年 zhouyuxi. All rights reserved.
//

#import "ModelController.h"
//#import <ReactiveCocoa/ReactiveCocoa.h>//函数响应编程框架!!
#import "ReactiveObjC.h"
#import "LoginViewModel.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"


@interface ModelController ()
@property (nonatomic,strong) RACSignal *singal;
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic,strong) LoginViewModel *viewModel;

@end

@implementation ModelController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    // [self setLogin];
    [self MVVMTest];
}

//-(NSArray *)mergeSortWithArray:(NSArray *)arrData
//{
//    if(arrData.count <=1 )    return arrData;
//
//    NSInteger mid = arrData.count/2;
//    NSArray *leftArray = [self mergeSortWithArray:[arrData subarrayWithRange:NSMakeRange(0, mid)]];
//    NSArray *rightArray = [self mergeSortWithArray:[arrData subarrayWithRange:NSMakeRange(mid,arrData.count-mid)]];
//
//    return [self mergeWithLeftArray:leftArray rightArray:rightArray];
//}
//
//-(NSArray *)mergeWithLeftArray:(NSArray *)leftArray rightArray:(NSArray *)rigthArray
//{
//    int l = 0;
//    int r = 0;
//    NSMutableArray *resultArray = [NSMutableArray array];
//
//    while (l<leftArray.count && r<rigthArray.count) {
//        if (leftArray[l]<rigthArray[r]) {
//            [resultArray addObject:leftArray[l++]];
//        }
//        else{
//            [resultArray addObject:rigthArray[r++]];
//        }
//    }
//
//    [resultArray addObject:(leftArray.lastObject>rigthArray.lastObject)?leftArray.lastObject:rigthArray.lastObject];
//
//    return resultArray;
//}
//- (LoginViewModel *)viewModel
//{
//    if (_viewModel == nil ) {
//        _viewModel = [[LoginViewModel alloc] init];
//    }
//    return _viewModel;
//}

- (void)MVVMTest
{
    if (_viewModel == nil ) {
        _viewModel = [[LoginViewModel alloc] init];
    }
    
    RAC(self.viewModel,account) = _accountField.rac_textSignal;
    RAC(self.viewModel,pwd) = _passwordField.rac_textSignal;
    RAC(_loginBtn,enabled) = self.viewModel.combineSignal;  // 给某个对象的某个属性绑定信号，一旦信号产生数据，就将内容赋值给属性
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"点击了登录按钮");
        //        [self.viewModel.commond execute:@"账号 密码"];
        [self.viewModel.subjectSource sendNext:@"账号 密码"];
    }];
}

- (void)setLogin
{
    // 组合
    //reduceBlock参数：根据组合的信号关联，必须一一对应！！
    RACSignal *signal =   [RACSignal combineLatest:@[_accountField.rac_textSignal,_passwordField.rac_textSignal] reduce:^id _Nullable(NSString *account ,NSString *pwd){
        return @(account.length && pwd.length);
    }];
    
    //    [signal subscribeNext:^(id  _Nullable x) {
    //        _loginBtn.enabled = [x boolValue];
    //    }];
    
    RAC(_loginBtn,enabled) = signal;  // 给某个对象的某个属性绑定信号，一旦信号产生数据，就将内容赋值给属性
    
    //创建命令
    RACCommand *commond = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        // 处理密码加密等事件
        NSLog(@"准备发送数据--%@",input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            // 这里请求网络数据拿到数据发送数据
            [subscriber sendNext:@"请求登录的数据"];
            [subscriber sendCompleted];
            return  nil;
        }];
    }];
    
    //获取命令中的信号源，订阅
    [commond.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    
    //    [commond.executing subscribeNext:^(NSNumber * _Nullable x) { // 没有执行 执行  结束
    //        NSLog(@"Number---%@",x);
    //    }];
    
    [[commond.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) { // 跳到1
        if ([x boolValue]) {
            NSLog(@"显示菊花");
            
            [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
            
        }else{
            NSLog(@"隐藏菊花");
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
        }
    }];
    
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"点击了登录按钮");
        [commond execute:@"账号 密码"];
    }];
}

- (void)filter
{
    // 过滤
    [[_accountField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        if (value.length < 5) {
            return YES;
        }else{
            return NO;
        }
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x); // <5的时候才来这里
        
    }];
}


- (void)testXunhuanyinyong
{
    @weakify(self);
    RACSignal *singal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSLog(@"%@",self);
        
        [subscriber sendNext:@"发送数据"];
        return  nil;
    }];
    
    
    [singal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    _singal = singal;
}
- (void)dealloc {
    
    NSLog(@"控制器走了");
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)disMiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
