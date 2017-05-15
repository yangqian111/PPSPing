//
//  PPSPingServices.m
//  PPS
//
//  Created by 羊谦 on 2016/12/9.
//  Copyright © 2016年 羊谦. All rights reserved.
//

#import "PPSPingServices.h"
#import "PPSPing.h"
#import "PPSPingSummary.h"

@interface PPSPingServices()<PPSPingDelegate>

{
    BOOL _hasStarted;
    NSInteger   _sequenceNumber;
    NSMutableArray *_pingItems;
}

@property (nonatomic, copy)   NSString   *address;
@property (nonatomic, strong) PPSPing *ping;
@property (nonatomic, strong) NSTimer *timer;
//  发包次数，默认100个包
@property(nonatomic, assign) NSInteger  maximumPingTimes;

@property(nonatomic, copy) PingsBackHandler handler;

@end


@implementation PPSPingServices

+ (instancetype)serviceWithAddress:(NSString *)address {
    PPSPingServices *services = [[PPSPingServices alloc] initWithAddress:address];
    return services;
}

+(instancetype)serviceWithAddress:(NSString *)address maximumPingTimes:(NSInteger)count {
     PPSPingServices *services = [[PPSPingServices alloc] initWithAddress:address maximumPingTimes:count];
    return services;
}

-(void)startWithCallbackHandler:(PingsBackHandler)handler {
    self.handler = [handler copy];
    [self startPing];
}

- (instancetype)initWithAddress:(NSString *)address{
    self = [self initWithAddress:address maximumPingTimes:100];
    return self;
}

- (instancetype)initWithAddress:(NSString *)address maximumPingTimes:(NSInteger)maximumPingTimes {
    self = [super init];
    if (self) {
        _maximumPingTimes = maximumPingTimes-1;
        _address = [address copy];
        _ping = [PPSPing new];
        _ping.host = _address;
        _ping.delegate = self;
        _ping.timeout = 1;
        _ping.pingPeriod = 0.9;
        _pingItems = [NSMutableArray arrayWithCapacity:_maximumPingTimes];
    }
    return self;
}

- (void)startPing {
    
    [self.ping setupWithBlock:^(BOOL success, NSError *error) {
        if (success) {
            [self.ping startPinging];
        } else {
            NSLog(@"ping失败");
            PPSPingSummary *summary = [[PPSPingSummary alloc] init];
            summary.status = PPSPingStatusFinished;
            [_pingItems addObject:summary];
            self.handler(summary, _pingItems);
        }
    }];
}


- (void)cancel {
    [self.ping stop];
}

-(void)ping:(PPSPing *)pinger didFailWithError:(NSError *)error {
    PPSPingSummary *summary = [[PPSPingSummary alloc] init];
    summary.status = PPSPingStatusError;
    [self handlSummary:summary];
}

-(void)ping:(PPSPing *)pinger didTimeoutWithSummary:(PPSPingSummary *)summary {
    [self handlSummary:summary];
}

-(void)ping:(PPSPing *)pinger didSendPingWithSummary:(PPSPingSummary *)summary {
    if (_hasStarted) {
        _hasStarted = YES;
        [self handlSummary:summary];
    }
}

-(void)ping:(PPSPing *)pinger didReceiveReplyWithSummary:(PPSPingSummary *)summary {
    [self handlSummary:summary];
}

-(void)ping:(PPSPing *)pinger didFailToSendPingWithSummary:(PPSPingSummary *)summary error:(NSError *)error {
    [self handlSummary:summary];
}

-(void)ping:(PPSPing *)pinger didReceiveUnexpectedReplyWithSummary:(PPSPingSummary *)summary {
    [self handlSummary:summary];
}

- (void)handlSummary:(PPSPingSummary *)summary {
    if (summary.sequenceNumber == _maximumPingTimes) {
        summary.status = PPSPingStatusFinished;
        _hasStarted = NO;
        [self.ping stop];
    }
    [_pingItems addObject:summary];
    NSLog(@"%@",summary);
    if (self.handler) {
        self.handler(summary, _pingItems);
    }
}

///**
// 计算ping的最大值 最小值 平均值
// */
- (NSString *)statisticsPingInfo {
//    NSMutableArray *pings = [NSMutableArray array];
//    double countTime = 0.0;
//    for (PPSPingItem *item in _pingItems) {
//        if (item.timeMilliseconds>0) {
//            [pings addObject:item];
//            countTime += item.timeMilliseconds;
//        }
//    }
//    double averageTime = countTime/pings.count;
//    NSNumber *maxTime = [pings valueForKeyPath:@"@max.timeMilliseconds"];
//    NSNumber *minTime = [pings valueForKeyPath:@"@min.timeMilliseconds"];
//    NSString *resultString = [NSString stringWithFormat:@"最大响应时间：%@\n最小响应时间：%@\n平均响应时间：%f",maxTime,minTime,averageTime];
//    return resultString;
    return @"";
}
//
+ (NSString *)statisticsStringWithPingItems:(NSArray *)pingItems {
//    NSString *address = [pingItems.firstObject originalAddress];
//    __block NSInteger receivedCount = 0, allCount = 0;
//    [pingItems enumerateObjectsUsingBlock:^(PPSPingItem *obj, NSUInteger idx, BOOL *stop) {
//        if (obj.status != PPSPingStatusFinished && obj.status != PPSPingStatusError && obj.status != PPSPingStatusDidStart) {
//            allCount ++;
//            if (obj.status == PPSPingStatusDidReceivePacket) {
//                receivedCount ++;
//            }
//        }
//    }];
//    
//    NSMutableString *description = [NSMutableString stringWithCapacity:50];
//    [description appendFormat:@"--- %@ ping statistics ---\n", address];
//    
//    CGFloat lossPercent = (CGFloat)(allCount - receivedCount) / MAX(1.0, allCount) * 100;
//    [description appendFormat:@"%ld packets transmitted, %ld packets received, %.1f%% packet loss\n", (long)allCount, (long)receivedCount, lossPercent];
//    return [description stringByReplacingOccurrencesOfString:@".0%" withString:@"%"];
    return @"";
}
//
//+ (CGFloat)statisticsWithPingItems:(NSArray *)pingItems{
//    __block NSInteger receivedCount = 0, allCount = 0;
//    [pingItems enumerateObjectsUsingBlock:^(PPSPingSummary *obj, NSUInteger idx, BOOL *stop) {
//        if (obj.status != PPSPingStatusFinished && obj.status != PPSPingStatusError && obj.status != PPSPingStatusDidStart) {
//            allCount ++;
//            if (obj.status == PPSPingStatusDidReceivePacket) {
//                receivedCount ++;
//            }
//        }
//    }];
//    CGFloat lossPercent = (CGFloat)(allCount - receivedCount) / MAX(1.0, allCount) * 100;
//    return lossPercent;
//    return 0.0;
//}
//

@end
