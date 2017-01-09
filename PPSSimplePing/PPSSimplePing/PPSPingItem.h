//
//  PPSPingItem.h
//  PPSSimplePing
//
//  Created by 羊谦 on 2017/1/3.
//  Copyright © 2017年 羊谦. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PPSPingStatus){
    PPSPingStatusDidStart,//开始
    PPSPingStatusDidFailToSendPacket,//发送数据包失败
    PPSPingStatusDidReceivePacket,//收到数据包
    PPSPingStatusDidReceiveUnexpectedPacket,//数据包数据错误
    PPSPingStatusDidTimeout,//超时
    PPSPingStatusError,//错误
    PPSPingStatusFinished,//完成
};


@interface PPSPingItem : NSObject

/**
 
 ping www.163.com
 
 PING 163.xdwscache.ourglb0.com (183.134.24.71): 56 data bytes
 
 64 bytes from 183.134.24.71: icmp_seq=0 ttl=53 time=12.914 ms
 64 bytes from 183.134.24.71: icmp_seq=1 ttl=53 time=15.136 ms
 
 --- 163.xdwscache.ourglb0.com ping statistics ---
 2 packets transmitted, 2 packets received, 0.0% packet loss
 
 */

/**
 对应上面的一个ping解释属性
 */

@property(nonatomic) NSString *originalAddress; // 163.xdwscache.ourglb0.com

@property(nonatomic, copy) NSString *IPAddress;// 183.134.24.71

@property(nonatomic) NSUInteger dateBytesLength;// 64

@property(nonatomic) double     timeMilliseconds;//time

@property(nonatomic) NSInteger  timeToLive;//ttl

@property(nonatomic) NSInteger  ICMPSequence;//icmp_seq

@property(nonatomic) PPSPingStatus status;

@end
