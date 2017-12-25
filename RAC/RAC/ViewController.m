//
//  ViewController.m
//  RAC
//
//  Created by zhouyuxi on 2017/11/15.
//  Copyright © 2017年 zhouyuxi. All rights reserved.
//

#import "ViewController.h"
//#import <ReactiveCocoa/ReactiveCocoa.h>//函数响应编程框架!!
#import "KFC.h"
#import "ModelController.h"
#import "ReactiveObjC.h"
#import "RACReturnSignal.h"
#import "AppHttpTool.h"

@interface ViewController ()<clickDelegate>
@property (nonatomic,strong) id<RACSubscriber> subscriber;
@property (nonatomic,assign) int  time;
@property (nonatomic,strong) RACDisposable  *disposable;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//   [self kvoTest];
//   [self delegateTest];
//   [self notificitionTest];
//   [self testTouchupInside];
//   [self testTextField];
//   [self testSequenceArray];
//   [self testSequenceDict];
//   [self plist];//转模型
//   [self testLifeSelector];
//   [self textHong];
//   [self testMulticastConnection];
//   [self testCommond];
//   [self switchToLatest];
//   [self testTimer];
//   [self bind];
//   [self testFlattenMap];
//   [self testFlattenMap1];
//   [self map];
//   [self concatTest];
//   [self then];
//   [self zipTest];
//   [self ignore];
//   [self takeTest];
//   [self takeUntil];

//   [self distinctUntilChangedTest];
      [self skip];
//   [self subjectTest];
//    // 订阅信号（接受消息数据）--热信号
//   [self.myView.signal subscribeNext:^(id x) {
//        self.view.backgroundColor = x;
//    }];
}

- (void)defaultMethod
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
     [subscriber sendNext:@"发送信号"];
        return nil;
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    
}

- (void)skip // 跳跃几个值 和 take 相反
{
    RACSubject *subject = [RACSubject subject];
    // 忽略掉第一次重复内容
    [[subject skip:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject sendNext:@"3"];
}

- (void)distinctUntilChangedTest
{
     RACSubject *subject = [RACSubject subject];
    // 忽略掉第一次重复内容
    [[subject distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        NSLog(@"distinctUntilChangedTest--%@",x);// 1 2 1 2
    }];
    
     [subject sendNext:@"1"];
     [subject sendNext:@"1"];
     [subject sendNext:@"2"];
     [subject sendNext:@"1"];
     [subject sendNext:@"2"];
     [subject sendNext:@"2"];
}

- (void)takeUntil // 直到标记信号发送数据的时候结束
{
    RACSubject *subject = [RACSubject subject];
    
    
    //标记信号
    RACSubject *signal = [RACSubject subject];
    
    [[subject takeUntil:signal] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];

    [subject sendNext:@"1"];
    [signal sendNext:@"..."];// [signal sendCompleted];
    
    [subject sendNext:@"2"];
    [subject sendNext:@"3"];
    [subject sendCompleted];
}

- (void)takeTest // 指定拿前面哪几个数据(从前往后) takeLast(从后往前)
{
     RACSubject *subject = [RACSubject subject];
    [[subject take:2] subscribeNext:^(id  _Nullable x) { //takeLast
        NSLog(@"%@",x);
    }];
    
    
    [[subject takeLast:2] subscribeNext:^(id  _Nullable x) { //takeLast 一定要写结束
        NSLog(@"%@",x);
    }];
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject sendNext:@"3"];
    
    [subject sendCompleted];
}


- (void)ignore
{
    RACSubject *subject = [RACSubject subject];
    RACSignal *ignoreSignal = [subject ignore:@"1"];
    [ignoreSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"1"];
    [subject sendNext:@"12"];
    [subject sendNext:@"13"];
    
}
- (void)zipTest
{
    
    // zipWith:两个信号压缩，只有当两个信号同时发出信号内容，并且将内容合并成一个元祖给你
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACSubject subject];
    
    // 压缩
    RACSignal *zipSignal  = [signalA zipWith:signalB];
    
    [zipSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [signalA sendNext:@"A"];
    [signalB sendNext:@"B"];

}

- (void)mergeTest// 无序
{
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACSubject subject];
    RACSubject *signalC = [RACSubject subject];
    
    RACSignal *mergeSignal = [RACSignal merge:@[signalA,signalB,signalC]];
    
    
    //谁先发送数据 先输出谁
    [mergeSignal subscribeNext:^(id  _Nullable x) {
        // 任意信号发送内容就会来
        NSLog(@"%@",x);
    }];
    
    
    [signalC sendNext:@"c"];
    [signalA sendNext:@"a"];
    [signalB sendNext:@"b"];
}


- (void)then// 忽略
{
    RACSignal *signalA= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //发送请求
        NSLog(@"网络请求数据1");
        [subscriber sendNext:@"😁"];
       [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //发送请求
        NSLog(@"网络请求数据2");
        [subscriber sendNext:@"😓"];
        return nil;
    }];
    
    // 忽略A的数据，只拿B的数据，但是B的数据依赖A的数据，只有A的数据发送完成后才能拿到B的数据
    RACSignal *thenSignal = [signalA then:^RACSignal * _Nonnull{
        return signalB;
    } ];


    [thenSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

// 多个信号任务完成后再继续下面的任务
-(void)testLifeSelector
{
    RACSignal *singal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //发送请求
        NSLog(@"网络请求数据1");
        [subscriber sendNext:@"😁"];
        return nil;
    }];
    
    RACSignal *singal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //发送请求
        NSLog(@"网络请求数据1");
        [subscriber sendNext:@"😓"];
        return nil;
    }];
    
    [self rac_liftSelector:@selector(lifeTestWidtData1:Data2:) withSignalsFromArray:@[singal1,singal2]];
}


// 有序

- (void)concatTest
{
    RACSignal *signalA= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //发送请求
        NSLog(@"网络请求数据1");
        [subscriber sendNext:@"😁"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //发送请求
        NSLog(@"网络请求数据2");
        [subscriber sendNext:@"😓"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signalC = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //发送请求
        NSLog(@"网络请求数据3");
        [subscriber sendNext:@"😓"];
        return nil;
    }];
    
//  RACSignal *concatSignal = [[signalA concat:signalB] concat:signalC];
    
    RACSignal *concatSignal = [RACSignal concat:@[signalA,signalB,signalC]]; // 有序
    
    [concatSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)map // 映射
{
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    // 绑定
    [[subject map:^id _Nullable(id  _Nullable value) {
        //返回的就是需要处理的数据
        NSString *str = [NSString stringWithFormat:@"MMMM---%@",value];
        return str;

    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];

    [subject sendNext:@"123"];
    [subject sendNext:@"321"];
}

- (void)testFlattenMap
{
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    // 绑定信号
    
    RACSignal *bindSignal = [subject flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        //block调用：只要源信号发送数据，就会调用bindBlock
        //value:源信号发送的内容（字典转模型）
        NSLog(@"%@",value);
        
        NSString *str = [NSString stringWithFormat:@"MMMM---%@",value];
        
        // 返回信号不能为nil，这里需要返回一个RACReturnSignal （return 模型）
        return [RACReturnSignal return:str];
    }];
    
    //绑定的信号订阅信号
    [bindSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅信号接收数据----%@",x);
    }];
    
    // 源信号发送信号
    [subject sendNext:@"发送数据"];
}

- (void)testFlattenMap1// 一般用于信号中的信号
{
    // 创建信号
    RACSubject *subjectSource = [RACSubject subject];
    RACSubject *subject = [RACSubject subject];
    // 绑定信号
    RACSignal *bindSignal = [subjectSource flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return value;
    }];
    
    //绑定的信号订阅信号
    [bindSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅信号接收数据----%@",x);
    }];
    
    // 源信号发送信号
    [subjectSource sendNext:subject];
    
    // 数据信号发送数据
    [subject sendNext:@"111"];

}

- (void)bind
{
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    // 给源信号绑定一个信号
    RACSignal *bindSignal  = [subject bind:^RACSignalBindBlock _Nonnull{
        return  ^RACSignal * (id _Nullable value, BOOL *stop){
        
            //block调用：只要源信号发送数据，就会调用bindBlock
            //value:源信号发送的内容（字典转模型）
            NSLog(@"%@",value);
            
            // 返回信号不能为nil，这里需要返回一个RACReturnSignal （return 模型）
            return [RACReturnSignal return:value];
        };
    }];
    //绑定的信号订阅信号
    [bindSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅信号接收数据----%@",x);
    }];
    
    // 源信号发送信号
    [subject sendNext:@"发送数据"];
}

- (void)testTimer

{
    
    [self.timeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.timeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    // 点击方法
    [[self.timeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        _timeBtn.enabled = NO;
        _time = 10;
        // 倒计时
        
        self.disposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
            _time --;
            NSString *text = _time > 0 ? [NSString stringWithFormat:@"%ds",_time] : @"重新发送";
            [_timeBtn setTitle:text forState:UIControlStateNormal];
            
            if (_time > 0) {
                _timeBtn.enabled = NO;
            }else{
                _timeBtn.enabled = YES;
                // 取消订阅
                [_disposable dispose];
            }
        }];
    }];
}

- (void)switchToLatest
{
    RACSubject *signalSource = [RACSubject subject];
    RACSubject *signal1 = [RACSubject subject];
    RACSubject *signal2 = [RACSubject subject];
    RACSubject *signal3 = [RACSubject subject];
    
    // 订阅信号
    //    [signalSource subscribeNext:^(id x) {
    //        [x subscribeNext:^(id x) {
    //            NSLog(@"xxxx-----%@",x);
    //        }];
    //    }];
    
    [signalSource.switchToLatest subscribeNext:^(id x) {
        NSLog(@"xxxx-----%@",x);
        //xxxx-----3
    }];
    
    
    //发送信号
    [signalSource sendNext:signal1];
    [signalSource sendNext:signal2];
    [signalSource sendNext:signal3];
    
    // 发送数据
    [signal1 sendNext:@"1"];
    [signal2 sendNext:@"2"];
    [signal3 sendNext:@"3"];
    
}

- (void)testCommond
{
    //1  创建命令
    RACCommand *commond = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"input---%@",input);
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            // 发送数据
            [subscriber sendNext:@"执行完命令后产生的数据"];
            // 发送完成
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    // 监听命令有有没有执行完毕
    [commond.executing subscribeNext:^(NSNumber* x) {
        
        NSLog(@"Number----%@",x);
        if ([x boolValue]) { // 正在执行
            NSLog(@"正在执行");
        }else{
            NSLog(@"已经结束&&还没开始");
        }
    }];
    
    //    //executionSignals:信号源，发送信号的信号 一般不用
    //    [commond.executionSignals subscribeNext:^(RACSignal * x) {
    //        [x subscribeNext:^(id x) {
    //            NSLog(@"%@",x);
    //        }];
    //    }];
    //
    
    //switchToLatest:最新的信号
    //    [commond.executionSignals.switchToLatest subscribeNext:^(id x) {
    //        NSLog(@"switchToLatest----%@",x);
    //    }];
    
    
    
    // 2 执行命令
    RACSignal *signal = [commond execute:@"输入执行的命令"];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
}

- (void)testMulticastConnection
{
    //不管订阅多少次信号，就只请求一次数据
    //RACMulticastConnection 必须要有信号
    //1 创建信号
    RACSignal *singal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //发送网络请求
        NSLog(@"发送网络请求");
        // 发送是数据
        [subscriber sendNext:@"请求到的数据"];
        return nil;
    }];
    //2 将信号转成链接类！
    RACMulticastConnection *connection = [singal publish];
    //3 订阅链接类的信号
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"A处在处理数据%@",x);
    }];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"B处在处理数据%@",x);
    }];
    
    //4 链接
    [connection connect];
}

- (void)textHong
{
    //    [[self.myField rac_textSignal] subscribeNext:^(id x) {
    //        _textLabel.text = [NSString stringWithFormat:@"%@",x];
    //    }];
    // 给某个对象的某个属性绑定信号，一旦信号产生数据，就将内容赋值给属性
    RAC(_textLabel,text) = self.myField.rac_textSignal;
    
    //kvo 监听
    [RACObserve(_textLabel, text) subscribeNext:^(id x) {
        NSLog(@"observe---%@",x);
    }];
    
    
    // 包装元祖
    RACTuple *tuple = RACTuplePack(@"1",@"2");
    NSLog(@"%@",tuple);
    
    // 解包
    RACTupleUnpack(NSString *str,NSString *str1) = tuple;
    NSLog(@"unpack --- %@,%@",str,str1);
    
}




- (void)lifeTestWidtData1:(NSString *)data1 Data2:(NSString *)data2
{
    NSLog(@"life---%@---%@",data1,data2);
    
}

- (void)plist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"kfc.plist" ofType:nil];
    NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
    
    //    NSMutableArray *dataArray = [NSMutableArray array];
    //    [dictArray.rac_sequence.signal subscribeNext:^(NSDictionary* x) {
    //        NSLog(@"%@",x);
    //        KFC *kfc = [KFC kfcWithDcit:x];
    //        [dataArray addObject:kfc];
    //    }];
    
    
    //将所有元素映射成新的对象，变成数组返回
    NSArray *dataArray =[[dictArray.rac_sequence map:^id(NSDictionary* value) {
        // 返回模型
        return [KFC kfcWithDcit:value];
    }] array];
    
    NSLog(@"%@",dataArray);
}

//RACSequence: 用于代替NSArry ,NSDictionary ,可以快速遍历，应用场景：字典转模型！！
- (void)testSequenceArray
{
    NSArray *arr =@[@"aaa",@"bbb",@111];
    //    //RAC 集合
    //    RACSequence *seq = arr.rac_sequence;
    //    //遍历
    //    RACSignal *signal = seq.signal;
    //    //订阅信号
    //    [signal subscribeNext:^(id x) {
    //        NSLog(@"secque----%@",x);
    //    }];
    
    [arr.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"secque----%@",x);
    }];
}

- (void)testSequenceDict
{
    NSDictionary *dict = @{@"name":@"周",@"age":@"20"};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple* x) {
        //        NSLog(@"dict --- %@",x);
        //        NSString *key = x[0];
        //        NSString *value = x[1];
        //        NSLog(@"key---%@ value---%@",key,value);
        
        
        //遍历所有的元祖，分别输出对应的key value
        RACTupleUnpack(NSString *key ,NSString *value) = x;
        NSLog(@"key---%@ value---%@",key,value);
    }];
}

- (void)testTuple
{
    // 元祖
    RACTuple *tuple = [RACTuple tupleWithObjectsFromArray:@[@"aaa",@"bbb",@111]];
    NSString *str = tuple[0];
    NSLog(@"%@",str);
    
}

- (void)testTextField
{
    [[self.myField rac_textSignal] subscribeNext:^(id x) {
        NSLog(@"text ---%@",x);
        // 这里输出的是所有内容
        
    }];
}

- (void)testTouchupInside
{
    [[self.myView.redBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"点击了");
    }];
}

// 代替通知
- (void)notificitionTest
{
    //    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification* x) {
    //        NSLog(@"键盘---%@",x);
    //    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"111" object:nil] subscribeNext:^(NSNotification* x) {
        NSLog(@"通知---%@",x.name);
        NSLog(@"%@", x.object);
        
        
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti) name:@"222" object:nil];
}

- (void)noti
{
    NSLog(@"这里");
}

// 代替代理
- (void)delegateTest
{
    
    self.myView.mydelegate = self;
    //    [[self.myView rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(id x) {
    //        NSLog(@"%@",x);
    //    }];
    
    [[self.myView rac_signalForSelector:@selector(laile:)] subscribeNext:^(RACTuple* x) {
        NSLog(@"%@",x);
        RACTupleUnpack(NSString *str)= x;
        NSLog(@"%@",str);
    }];
}

- (void)clickMethod:(NSString *)str
{
    NSLog(@"%@",str);
}


// kvo
- (void)kvoTest
{
    //        [[self.myView rac_valuesForKeyPath:@"frame" observer:nil] subscribeNext:^(id x) {
    //            NSLog(@"kvo----%@",x);
    //        }];
    //
    
    [[RACObserve(self.myView, frame) filter:^BOOL(id value) {
        NSLog(@"%@",value);
        return YES;
    }] subscribeNext:^(id x) {
        NSLog(@"HHH---%@",x);
    }];;
    
}


- (void)signal
{
    //1.创建信号(冷信号)
    RACSignal *signal  = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) { // 这个block在第二部订阅信号的时候调用（执行）
        _subscriber = subscriber; // 强引用一下就不会主动取消订阅，后面可以手动取消订阅
        //3.发送信号
        [subscriber sendNext:@"哈哈哈"]; // 默认一个信号发送数据完毕后会主动取消订阅，订阅者（subscriber 销毁）
        // 只要订阅者在，就不会自动取消订阅（）强引用一下
        return [RACDisposable disposableWithBlock:^{
            
            NSLog(@"取消订阅了！");
            
            // 只要取消订阅就会来这里
        }];
    }];
    
    //2.订阅信号(热信号)
    // 这里处理数据，展示UI界面
    RACDisposable *disposable =   [signal subscribeNext:^(id x) { // 这个block在第三步骤发送信号的的时候调用（执行）
        //x : 信号发送的内容
        NSLog(@"%@",x);
    }];
    
    // 手动取消订阅
    [disposable dispose];
}

- (void)subjectTest
{
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    
    //订阅信号
    //处理订阅：拿到之前的订阅者数组保存订阅者
    // 可以有多个订阅者
    [subject subscribeNext:^(id x) {
        NSLog(@"订阅一接受到了数据%@",x);
    }];
    //    [subject subscribeNext:^(id x) {
    //        NSLog(@"订阅二接受到了数据%@",x);
    //    }];
    //发送数据，发送信号
    // 遍历出所有的订阅者，调用nextBlock
    [subject sendNext:@"🍔"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    static int x = 50;
    x++;
    self.myView.frame = CGRectMake(x, 50, 200, 200);
}


- (IBAction)model:(id)sender {
    
}
@end
