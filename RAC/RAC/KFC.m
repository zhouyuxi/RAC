//
//  KFC.m
//  RAC
//
//  Created by zhouyuxi on 2017/11/20.
//  Copyright © 2017年 zhouyuxi. All rights reserved.
//

#import "KFC.h"

@implementation KFC

+(instancetype)kfcWithDcit:(NSDictionary *)dict
{
    KFC *kfc = [[KFC alloc] init];
    [kfc setValuesForKeysWithDictionary:dict];
    return kfc;
}
@end
