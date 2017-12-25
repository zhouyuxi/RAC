//
//  LoginViewModel.h
//  RAC
//
//  Created by zhouyuxi on 2017/11/23.
//  Copyright © 2017年 zhouyuxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"

@interface LoginViewModel : NSObject

@property (nonatomic,copy) NSString *account;
@property (nonatomic,copy) NSString *pwd;

/**  处理登录按钮能否点击的信号 */
@property (nonatomic,strong) RACSignal *combineSignal;

/** 登录按钮命令  */
@property (nonatomic,strong) RACCommand *commond;

// 源信号
@property (nonatomic,strong) RACSubject *subjectSource;


@end
