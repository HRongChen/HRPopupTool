//
//  HRDetailViewController.m
//  HRPopup_Example
//
//  Created by Gavin on 2020/3/12.
//  Copyright © 2020 华荣 陈. All rights reserved.
//

#import "HRDetailViewController.h"
#import "HRViewController.h"
#import <HRPopup/HRPopup.h>
#import "HRViewController.h"
#import "HRAlertViewController.h"
@interface HRDetailViewController ()

@end

@implementation HRDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showNow:(UIButton *)sender {
    HRPopupConfiguration *config = [[HRPopupConfiguration alloc] init];
    config.queueEnable = NO;
    config.showInterval = arc4random() % 5;;
    [HRPopupManager showWithConfiguration:config
                              completionHandler:^UIViewController * _Nonnull(HRPopupService * _Nullable service) {
        HRAlertViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HRAlertViewController"];
        vc.desc = [NSString stringWithFormat:@"showTime=%f\ndelayTime=%f",service.configuration.showInterval,service.configuration.delayInterval];
        vc.dismiss = ^{
            [service dismiss];
        };
        return vc;
    }];
}
- (IBAction)showInHome:(UIButton *)sender {
    
    HRPopupConfiguration *config = [[HRPopupConfiguration alloc] init];
    config.queueEnable = YES;
    config.delayInterval = arc4random() % 2;
    config.showInterval = arc4random() % 3;
    config.whiteList = @[@"HRViewController"];
    //    config.whiteList = @[NSStringFromClass(HRViewController.class)];
    [HRPopupManager showWithConfiguration:config
                              completionHandler:^UIViewController * _Nonnull(HRPopupService * _Nullable service) {
        HRAlertViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HRAlertViewController"];
        vc.desc = [NSString stringWithFormat:@"showTime=%f\ndelayTime=%f",service.configuration.showInterval,service.configuration.delayInterval];
        vc.dismiss = ^{
            [service dismiss];
        };
        return vc;
    }];
}



@end
