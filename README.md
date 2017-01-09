# PPSSimplePing
iOS端的一个ping网络工具，采用了苹果官方提供的SimplePingdemo

### SimplePing

Apple官方的demo SimplePing ，能够实现网络ping功能，但是有一些其他的数据不能够得到，例如存活时间，响应时间等等，下面是官方例子：

https://developer.apple.com/library/content/samplecode/SimplePing/Introduction/Intro.html

![](http://o8bxt3lx0.bkt.clouddn.com/blog/2017-01-03-053734.jpg)

### 改动后的PPSSimplePing

改动后的SimplePing能够计算出响应时间，得到域名的ip地址，存活时间等等。

### PPSPingItem

新建一个我们的自己的工程，将刚才下载的例子中的SimplePing 头文件和实现文件 两个文件拷贝到我们的工程中

首先，我们新建一个model PPSPingItem  用来封装我们在网络ping过程中，返回的一些数据，便于数据展示

我们来看一张电脑的终端ping的样式：

![](http://o8bxt3lx0.bkt.clouddn.com/blog/2017-01-03-054734.jpg)

我们在手机端要实现的也是这种效果

PPSPingItem：

```
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

```

PPSPingItem中的属性，在我们ping网络过程中，返回数据时需要用到。

### PPSPingServices

PPSPingServices是一个服务类，用作ping的入口，一个管理类，供外部调用，在PPSPingServices类中，我将发起网络ping的接口做成了block，当然，如果你更喜欢delegate，也可以使用delegate实现

首先，一个类方法，调起Ping服务

```
/**
 开始收集Ping网络消息
 
 @param address 域名
 @param handler 回调包信息 每次收到的网络信息
 @return PPSPingServices
 */
+ (PPSPingServices *)startPingAddress:(NSString *)address
                      callbackHandler:(void(^)(PPSPingItem *pingItem, NSArray *pingItems))handler;
```

在实现文件中，我们需要实现SimplePingDelegate，delegate中一共有6个方法，分别对应这ping的不同状态

```
//开始进行网络检测
- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address;
//网络检测失败
- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error;
//发送网络包成功
- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber;
//发送网络包失败
- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error;
//收到网络包回应
- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber;
//收到错误的网络包
- (void)simplePing:(SimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet;
```

开始ping网络数据：

```
/**
 开始网络ping网络

 @param sender 按钮
 */
- (IBAction)startPing:(id)sender {
 self.pingService = [PPSPingServices startPingAddress:_domainTextFiled.text callbackHandler:^(PPSPingItem *pingItem, NSArray *pingItems) {
     NSLog(@"%@",pingItem);
 }];
}
```

在服务类中，我们开始ping网络，会在6个delegate方法中，分别获得ping网络的返回值

看一下效果图：

![](http://o8bxt3lx0.bkt.clouddn.com/blog/2017-01-09-iOSping%E5%B0%8F%E5%B7%A5%E5%85%B7.gif)

后面如果还有时间，会接着完善
