//
//  PPSPingServices.h
//  PPSSimplePing
//
//  Created by 羊谦 on 2017/1/3.
//  Copyright © 2017年 羊谦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


@class PPSPingItem;
@interface PPSPingServices : NSObject


/// 超时时间, default 500ms
@property(nonatomic) double timeoutMilliseconds;


/**
 开始收集Ping网络消息
 
 @param address 域名
 @param handler 回调包信息
 @return PPSPingServices
 */
+ (PPSPingServices *)startPingAddress:(NSString *)address
                      callbackHandler:(void(^)(PPSPingItem *pingItem, NSArray *pingItems))handler;
//  发包次数，默认10个包
@property(nonatomic) NSInteger  maximumPingTimes;

- (void)cancel;

/**
 计算丢包率
 
 @param pingItems 传入包
 数组
 @return 返回丢包率字符串描述
 */
+ (NSString *)statisticsStringWithPingItems:(NSArray *)pingItems;

/**
 计算丢包率
 
 @param pingItems 传入包数组
 @return 直接返回计算后得到的丢包率
 */
+ (CGFloat)statisticsWithPingItems:(NSArray *)pingItems;

@end
