//
//  NAQOSPing.h
//  NAQOS
//
//  Created by ppsheep on 2017/4/24.
//  Copyright © 2017年 羊谦. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "NAQOSPingSummary.h"

@class NAQOSPingSummary;
@protocol NAQOSPingDelegate;

typedef void(^StartupCallback)(BOOL success, NSError *error);

@interface NAQOSPing : NSObject

@property (weak, nonatomic) id<NAQOSPingDelegate>      delegate;

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

@protocol NAQOSPingDelegate <NSObject>

@optional

-(void)ping:(NAQOSPing *)pinger didFailWithError:(NSError *)error;
-(void)ping:(NAQOSPing *)pinger didSendPingWithSummary:(NAQOSPingSummary *)summary;
-(void)ping:(NAQOSPing *)pinger didFailToSendPingWithSummary:(NAQOSPingSummary *)summary error:(NSError *)error;
-(void)ping:(NAQOSPing *)pinger didTimeoutWithSummary:(NAQOSPingSummary *)summary;
-(void)ping:(NAQOSPing *)pinger didReceiveReplyWithSummary:(NAQOSPingSummary *)summary;
-(void)ping:(NAQOSPing *)pinger didReceiveUnexpectedReplyWithSummary:(NAQOSPingSummary *)summary;

@end
