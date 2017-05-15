//
//  PPSPingServices.h
//  PPS
//
//  Created by 羊谦 on 2016/12/9.
//  Copyright © 2016年 羊谦. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <CoreGraphics/CoreGraphics.h>

@class PPSPingSummary;

typedef void(^PingsBackHandler)(PPSPingSummary *pingItem, NSArray *pingItems);

@interface PPSPingServices : NSObject

+ (instancetype)serviceWithAddress:(NSString *)address;



+ (instancetype)serviceWithAddress:(NSString *)address
                  maximumPingTimes:(NSInteger)count;

/**
 开始收集

 @param handler 回调处理
 */
- (void)startWithCallbackHandler:(PingsBackHandler)handler;

- (void)cancel;

/**
 计算丢包率
 
 @param pingItems 传入包
 数组
 @return 返回丢包率字符串描述
 */
//+ (NSString *)statisticsStringWithPingItems:(NSArray *)pingItems;


/**
 计算丢包率
 
 @param pingItems 传入包数组
 @return 直接返回计算后得到的丢包率
 */
//+ (CGFloat)statisticsWithPingItems:(NSArray *)pingItems;


@end
