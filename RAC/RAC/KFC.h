//
//  KFC.h
//  RAC
//
//  Created by zhouyuxi on 2017/11/20.
//  Copyright © 2017年 zhouyuxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KFC : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *icon;

+(instancetype)kfcWithDcit:(NSDictionary *)dict;

@end
