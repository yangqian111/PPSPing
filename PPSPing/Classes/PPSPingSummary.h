//
//  PPSPingSummary.h
//  PPS
//
//  Created by ppsheep on 2017/4/24.
//  Copyright © 2017年 羊谦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPSPingSummary : NSObject <NSCopying>

typedef enum {
    PPSPingStatusDidStart,
    PPSPingStatusDidFailToSendPacket,
    PPSPingStatusDidReceivePacket,
    PPSPingStatusDidReceiveUnexpectedPacket,
    PPSPingStatusDidTimeout,
    PPSPingStatusError,
    PPSPingStatusFinished,
} PPSPingStatus;

@property (assign, nonatomic) NSUInteger        sequenceNumber;
@property (assign, nonatomic) NSUInteger        payloadSize;
@property (assign, nonatomic) NSUInteger        ttl;
@property (strong, nonatomic) NSString          *host;
@property (strong, nonatomic) NSDate            *sendDate;
@property (strong, nonatomic) NSDate            *receiveDate;
@property (assign, nonatomic) NSTimeInterval    rtt;
@property (assign, nonatomic) PPSPingStatus      status;

@end
