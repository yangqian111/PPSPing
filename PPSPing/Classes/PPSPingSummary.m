//
//  PPSPingSummary.m
//  PPS
//
//  Created by ppsheep on 2017/4/24.
//  Copyright © 2017年 羊谦. All rights reserved.
//

#import "PPSPingSummary.h"

@implementation PPSPingSummary

#pragma mark - custom acc

-(void)setHost:(NSString *)host {
    _host = host;
}

-(NSTimeInterval)rtt {
    if (self.sendDate) {
        return [self.receiveDate timeIntervalSinceDate:self.sendDate] * 1000;
    }
    else {
        return 0;
    }
}

#pragma mark - copying

-(id)copyWithZone:(NSZone *)zone {
    PPSPingSummary *copy = [[[self class] allocWithZone:zone] init];
    
    copy.sequenceNumber = self.sequenceNumber;
    copy.payloadSize = self.payloadSize;
    copy.ttl = self.ttl;
    copy.host = [self.host copy];
    copy.sendDate = [self.sendDate copy];
    copy.receiveDate = [self.receiveDate copy];
    copy.status = self.status;
    
    return copy;
}

#pragma mark - memory

-(id)init {
    if (self = [super init]) {
        self.status = PPSPingStatusDidStart;
    }
    
    return self;
}

-(void)dealloc {
    self.host = nil;
    self.sendDate = nil;
    self.receiveDate = nil;
}

#pragma mark - description

-(NSString *)description {
    NSString *statusString = nil;
    switch (self.status) {
        case PPSPingStatusError:
            statusString = @"PPSPingStatusError";
            return [NSString stringWithFormat:@"Can not ping to %@", self.host];
            break;
        case PPSPingStatusDidStart:
            statusString = @"PPSPingStatusDidStart";
            return [NSString stringWithFormat:@"PING %@ start",self.host];
            break;
        case PPSPingStatusFinished:
            statusString = @"PPSPingStatusFinished";
            return [NSString stringWithFormat:@"PING %@ finish",self.host];
            break;
        case PPSPingStatusDidTimeout:
            return [NSString stringWithFormat:@"Request timeout for icmp_seq %ld", (long)self.sequenceNumber];
            break;
        case PPSPingStatusDidReceivePacket:
            return [NSString stringWithFormat:@"%ld bytes: icmp_seq=%ld ttl=%ld time=%.3f ms", (long)self.payloadSize, (long)self.sequenceNumber, (long)self.ttl, self.rtt];
            break;
        case PPSPingStatusDidFailToSendPacket:
            return [NSString stringWithFormat:@"Fail to send packet: icmp_seq=%ld", (long)self.sequenceNumber];
            break;
        case PPSPingStatusDidReceiveUnexpectedPacket:
            return [NSString stringWithFormat:@"Receive unexpected: icmp_seq=%ld", (long)self.sequenceNumber];
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"status: %@, rtt: %f", statusString, self.rtt];
}

@end
