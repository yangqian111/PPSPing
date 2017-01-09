//
//  ViewController.m
//  PPSSimplePing
//
//  Created by 羊谦 on 2017/1/3.
//  Copyright © 2017年 羊谦. All rights reserved.
//

#import "ViewController.h"
#import "PPSPingServices.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *domainTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *startPingButton;
@property (weak, nonatomic) IBOutlet UITextView *logInfo;
@property (nonatomic, strong) NSMutableString *logText;

@property (nonatomic, strong) PPSPingServices *pingService;

@end

@implementation ViewController
{
    @private
    BOOL _hasStarted;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logText = [[NSMutableString alloc] init];
}

/**
 开始网络ping网络

 @param sender 按钮
 */
- (IBAction)Ping:(id)sender {
    if (_hasStarted) {
        [self.startPingButton setTitle:@"开始" forState:UIControlStateNormal];
        [self.pingService cancel];
        self.pingService = nil;
        _hasStarted = NO;
    }else{
        _hasStarted = YES;
        [self.startPingButton setTitle:@"结束" forState:UIControlStateNormal];
        self.pingService = [PPSPingServices startPingAddress:_domainTextFiled.text callbackHandler:^(PPSPingItem *pingItem, NSArray *pingItems) {
            NSString *string = [NSString stringWithFormat:@"%@\n",pingItem];
            [self.logText appendString:string];
            self.logInfo.text = self.logText;
            [self.logInfo scrollRangeToVisible:NSMakeRange(self.logInfo.text.length, 1)];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
