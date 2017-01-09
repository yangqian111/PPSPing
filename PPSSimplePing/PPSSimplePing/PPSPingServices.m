//
//  PPSPingServices.m
//  PPSSimplePing
//
//  Created by 羊谦 on 2017/1/3.
//  Copyright © 2017年 羊谦. All rights reserved.
//

#import "PPSPingServices.h"
#import "PPSPingItem.h"
#import "PPSSimplePing.h"

@interface PPSPingServices()<PPSSimplePingDelegate>

{
    BOOL _hasStarted;
    BOOL _isTimeout;
    NSInteger   _repingTimes;
    NSInteger   _sequenceNumber;
    NSMutableArray *_pingItems;
}

@property(nonatomic, copy)   NSString   *address;
@property(nonatomic, strong) PPSSimplePing *simplePing;

@property(nonatomic, strong)void(^callbackHandler)(PPSPingItem *item, NSArray *pingItems);

@end

@implementation PPSPingServices

+(PPSPingServices *)startPingAddress:(NSString *)address
                     callbackHandler:(void (^)(PPSPingItem *, NSArray *))handler{
    PPSPingServices *services = [[PPSPingServices alloc] initWithAddress:address];
    services.callbackHandler = handler;
    [services startPing];
    return services;
}

- (instancetype)initWithAddress:(NSString *)address{
    self = [super init];
    if (self) {
        self.timeoutMilliseconds = 500;//默认超时
        self.maximumPingTimes = 20;//ping的次数
        self.address = address;//host名称
        self.simplePing = [[PPSSimplePing alloc] initWithHostName:address];
        self.simplePing.addressStyle = PPSSimplePingAddressStyleAny;
        self.simplePing.delegate = self;
        _pingItems = [NSMutableArray arrayWithCapacity:20];
    }
    return self;
}

- (void)startPing {
    _repingTimes = 0;
    _hasStarted = NO;
    [_pingItems removeAllObjects];
    [self.simplePing start];
}

//重复发包
- (void)reping {
    [self.simplePing stop];
    [self.simplePing start];
}

- (void)_timeoutActionFired {
    PPSPingItem *pingItem = [[PPSPingItem alloc] init];
    pingItem.ICMPSequence = _sequenceNumber;
    pingItem.originalAddress = self.address;
    pingItem.status = PPSPingStatusDidTimeout;
    [self.simplePing stop];
    [self _handlePingItem:pingItem];
}

- (void)_handlePingItem:(PPSPingItem *)pingItem {
    if (pingItem.status == PPSPingStatusDidReceivePacket || pingItem.status == PPSPingStatusDidTimeout) {
        [_pingItems addObject:pingItem];
    }
    if (_repingTimes < self.maximumPingTimes - 1) {
        if (self.callbackHandler) {
            self.callbackHandler(pingItem, [_pingItems copy]);
        }
        _repingTimes ++;
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(reping) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    } else {
        if (self.callbackHandler) {
            self.callbackHandler(pingItem, [_pingItems copy]);
        }
        [self cancel];
    }
}

- (void)cancel {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(_timeoutActionFired) object:nil];       
    [self.simplePing stop];
    PPSPingItem *pingItem = [[PPSPingItem alloc] init];
    pingItem.status = PPSPingStatusFinished;
    [_pingItems addObject:pingItem];
    if (self.callbackHandler) {
        self.callbackHandler(pingItem, [_pingItems copy]);
    }
}

- (void)pps_simplePing:(PPSSimplePing *)pinger didStartWithAddress:(NSData *)address {
    if (!_hasStarted) {
        PPSPingItem *pingItem = [[PPSPingItem alloc] init];
        pingItem.originalAddress = self.address;
        pingItem.IPAddress = pinger.IPAddress;
        pingItem.status = PPSPingStatusDidStart;
        [_pingItems addObject:pingItem];
        _hasStarted = YES;
        if (self.callbackHandler) {
            self.callbackHandler(pingItem, nil);
        }
    }
    [pinger sendPacket:nil];
    //默认半秒超时，超时则在_timeoutActionFired方法中，设置超时
    [self performSelector:@selector(_timeoutActionFired) withObject:nil afterDelay:self.timeoutMilliseconds / 1000.0];
}

- (void)pps_simplePing:(PPSSimplePing *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber {
    _sequenceNumber = sequenceNumber;
}

- (void)pps_simplePing:(PPSSimplePing *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(_timeoutActionFired) object:nil];
    _sequenceNumber = sequenceNumber;
    PPSPingItem *pingItem = [[PPSPingItem alloc] init];
    pingItem.ICMPSequence = _sequenceNumber;
    pingItem.originalAddress = self.address;
    pingItem.status = PPSPingStatusDidFailToSendPacket;
    [self _handlePingItem:pingItem];
}

- (void)pps_simplePing:(PPSSimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(_timeoutActionFired) object:nil];
    PPSPingItem *pingItem = [[PPSPingItem alloc] init];
    pingItem.ICMPSequence = _sequenceNumber;
    pingItem.originalAddress = self.address;
    pingItem.status = PPSPingStatusDidReceiveUnexpectedPacket;
}

- (void)pps_simplePing:(PPSSimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet timeToLive:(NSInteger)timeToLive sequenceNumber:(uint16_t)sequenceNumber timeElapsed:(NSTimeInterval)timeElapsed {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(_timeoutActionFired) object:nil];
    PPSPingItem *pingItem = [[PPSPingItem alloc] init];
    pingItem.IPAddress = pinger.IPAddress;
    pingItem.dateBytesLength = packet.length;
    pingItem.timeToLive = timeToLive;
    pingItem.timeMilliseconds = timeElapsed * 1000;
    pingItem.ICMPSequence = sequenceNumber;
    pingItem.originalAddress = self.address;
    pingItem.status = PPSPingStatusDidReceivePacket;
    [self _handlePingItem:pingItem];
}

- (void)pps_simplePing:(PPSSimplePing *)pinger didFailWithError:(NSError *)error {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(_timeoutActionFired) object:nil];
    [self.simplePing stop];
    
    PPSPingItem *errorPingItem = [[PPSPingItem alloc] init];
    errorPingItem.originalAddress = self.address;
    errorPingItem.status = PPSPingStatusError;
    if (self.callbackHandler) {
        self.callbackHandler(errorPingItem, [_pingItems copy]);
    }
    
    PPSPingItem *pingItem = [[PPSPingItem alloc] init];
    pingItem.originalAddress = self.address;
    pingItem.IPAddress = pinger.IPAddress ?: pinger.hostName;
    [_pingItems addObject:pingItem];
    pingItem.status = PPSPingStatusFinished;
    if (self.callbackHandler) {
        self.callbackHandler(pingItem, [_pingItems copy]);
    }
}

+ (NSString *)statisticsStringWithPingItems:(NSArray *)pingItems {
    NSString *address = [pingItems.firstObject originalAddress];
    __block NSInteger receivedCount = 0, allCount = 0;
    [pingItems enumerateObjectsUsingBlock:^(PPSPingItem *obj, NSUInteger idx, BOOL *stop) {
        if (obj.status != PPSPingStatusFinished && obj.status != PPSPingStatusError) {
            allCount ++;
            if (obj.status == PPSPingStatusDidReceivePacket) {
                receivedCount ++;
            }
        }
    }];
    
    NSMutableString *description = [NSMutableString stringWithCapacity:50];
    [description appendFormat:@"--- %@ ping statistics ---\n", address];
    
    CGFloat lossPercent = (CGFloat)(allCount - receivedCount) / MAX(1.0, allCount) * 100;
    [description appendFormat:@"%ld packets transmitted, %ld packets received, %.1f%% packet loss\n", (long)allCount, (long)receivedCount, lossPercent];
    return [description stringByReplacingOccurrencesOfString:@".0%" withString:@"%"];
}

+ (CGFloat)statisticsWithPingItems:(NSArray *)pingItems{
    __block NSInteger receivedCount = 0, allCount = 0;
    [pingItems enumerateObjectsUsingBlock:^(PPSPingItem *obj, NSUInteger idx, BOOL *stop) {
        if (obj.status != PPSPingStatusFinished && obj.status != PPSPingStatusError) {
            allCount ++;
            if (obj.status == PPSPingStatusDidReceivePacket) {
                receivedCount ++;
            }
        }
    }];
    CGFloat lossPercent = (CGFloat)(allCount - receivedCount) / MAX(1.0, allCount) * 100;
    return lossPercent;
}

@end
