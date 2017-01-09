//
//  PPSPingItem.m
//  PPSSimplePing
//
//  Created by 羊谦 on 2017/1/3.
//  Copyright © 2017年 羊谦. All rights reserved.
//

#import "PPSPingItem.h"

@implementation PPSPingItem

- (NSString *)description {
    switch (self.status) {
        case PPSPingStatusDidStart:
            return [NSString stringWithFormat:@"PING %@ (%@): %ld data bytes",self.originalAddress, self.IPAddress, (long)self.dateBytesLength];
        case PPSPingStatusDidReceivePacket:
            return [NSString stringWithFormat:@"%ld bytes from %@: icmp_seq=%ld ttl=%ld time=%.3f ms", (long)self.dateBytesLength, self.IPAddress, (long)self.ICMPSequence, (long)self.timeToLive, self.timeMilliseconds];
        case PPSPingStatusDidTimeout:
            return [NSString stringWithFormat:@"Request timeout for icmp_seq %ld", (long)self.ICMPSequence];
        case PPSPingStatusDidFailToSendPacket:
            return [NSString stringWithFormat:@"Fail to send packet to %@: icmp_seq=%ld", self.IPAddress, (long)self.ICMPSequence];
        case PPSPingStatusDidReceiveUnexpectedPacket:
            return [NSString stringWithFormat:@"Receive unexpected packet from %@: icmp_seq=%ld", self.IPAddress, (long)self.ICMPSequence];
        case PPSPingStatusError:
            return [NSString stringWithFormat:@"Can not ping to %@", self.originalAddress];
        default:
            break;
    }
    if (self.status == PPSPingStatusDidReceivePacket) {
    }
    return super.description;
}

@end
