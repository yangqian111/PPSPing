//
//  PPSViewController.m
//  PPSPing
//
//  Created by ppsheep.qian@gmail.com on 05/15/2017.
//  Copyright (c) 2017 ppsheep.qian@gmail.com. All rights reserved.
//

#import "PPSViewController.h"
#import <PPSPing/PPSPingServices.h>

@interface PPSViewController ()

@property (nonatomic, strong) PPSPingServices *service;
@property (weak, nonatomic) IBOutlet UITextView *pingResultTextView;
@property (nonatomic, strong) NSMutableString *resultString;

@end

@implementation PPSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.resultString = [[NSMutableString alloc] initWithString:@"ping结果:\n"];
    self.service = [PPSPingServices serviceWithAddress:@"www.163.com"];
    [self.service startWithCallbackHandler:^(PPSPingSummary *pingItem, NSArray *pingItems) {
        NSLog(@"%@",pingItem);
        [self.resultString appendFormat:@"%@\n",pingItem];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.pingResultTextView.text = self.resultString;
        });
    }];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
