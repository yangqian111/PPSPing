//
//  PPSPing.h
//  PPS
//
//  Created by ppsheep on 2017/4/24.
//  Copyright © 2017年 羊谦. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "PPSPingSummary.h"

@class PPSPingSummary;
@protocol PPSPingDelegate;

typedef void(^StartupCallback)(BOOL success, NSError *error);

@interface PPSPing : NSObject

@property (weak, nonatomic) id<PPSPingDelegate>      delegate;

@property (copy, nonatomic) NSString                *host;
@property (assign, atomic) NSTimeInterval           pingPeriod;
@property (assign, atomic) NSTimeInterval           timeout;
@property (assign, atomic) NSUInteger               payloadSize;
@property (assign, atomic) NSUInteger               ttl;
@property (assign, atomic, readonly) BOOL           isPinging;
@property (assign, atomic, readonly) BOOL           isReady;

@property (assign, atomic) BOOL                     debug;

-(void)setupWithBlock:(StartupCallback)callback;
-(void)startPinging;
-(void)stop;

@end

@protocol PPSPingDelegate <NSObject>

@optional

-(void)ping:(PPSPing *)pinger didFailWithError:(NSError *)error;
-(void)ping:(PPSPing *)pinger didSendPingWithSummary:(PPSPingSummary *)summary;
-(void)ping:(PPSPing *)pinger didFailToSendPingWithSummary:(PPSPingSummary *)summary error:(NSError *)error;
-(void)ping:(PPSPing *)pinger didTimeoutWithSummary:(PPSPingSummary *)summary;
-(void)ping:(PPSPing *)pinger didReceiveReplyWithSummary:(PPSPingSummary *)summary;
-(void)ping:(PPSPing *)pinger didReceiveUnexpectedReplyWithSummary:(PPSPingSummary *)summary;

@end
