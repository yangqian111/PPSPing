# PPSPing
iOS端的一个ping网络工具，修复了之前不能够并发Ping的bug和不能够在子线程中发起的bug

此次版本还加入了pod支持，可以通过pod集成

### 集成方式

##### 源码

直接将PPSPing下的源码拷贝到工程目录中，在使用的时候直接引入PPSPingServices文件即可

##### pod方式引入

```
pod 'PPSPing', '~> 0.1.0'

```

### 回调说明

ping的结果与电脑端的ping方式相似，数据格式相同

### 使用方式

```objc

@interface PPSAppDelegate()

@property (nonatomic, strong) PPSPingServices *service;

@end

@implementation PPSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.service = [PPSPingServices serviceWithAddress:@"www.163.com"];
    [self.service startWithCallbackHandler:^(PPSPingSummary *pingItem, NSArray *pingItems) {
        NSLog(@"%@",pingItem);
    }];
    return YES;
}

@end
```

**注意：在使用时，需要service存在强引用，不然不能够收到回调结果**

###### 错误使用方式

```objc

@interface PPSAppDelegate()

//@property (nonatomic, strong) PPSPingServices *service;

@end

@implementation PPSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    PPSPingServices *service = [PPSPingServices serviceWithAddress:@"www.163.com"];
    [service startWithCallbackHandler:^(PPSPingSummary *pingItem, NSArray *pingItems) {
        NSLog(@"%@",pingItem);
    }];
    return YES;
}

@end
```

上面这种使用方式，将得不到回调结果，在block执行完成后，service已经销毁


看一下效果图：

![](http://o8bxt3lx0.bkt.clouddn.com/blog/2017-01-09-iOSping%E5%B0%8F%E5%B7%A5%E5%85%B7.gif)

后面如果还有时间，会接着完善
