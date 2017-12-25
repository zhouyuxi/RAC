//
//  AppHttpTool.h
//  RAC
//
//  Created by zhouyuxi on 2017/11/23.
//  Copyright © 2017年 zhouyuxi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^QSCSuccess)(id json);
typedef void (^QSCFailure)(NSError *error);

@interface AppHttpTool : NSObject


+ (void)post:(NSString *)url parameters:(id )parameters httpToolSuccess:(QSCSuccess)httpToolSuccess failure:(QSCFailure)failure;



@end
