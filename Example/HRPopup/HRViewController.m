//
//  HRViewController.m
//  HRPopup
//
//  Created by Gavin on 03/12/2020.
//  Copyright (c) 2020 Gavin. All rights reserved.
//

#import "HRViewController.h"
#import <HRPopup/HRPopup.h>
#import "HRAlertViewController.h"
#import "HRDetailViewController.h"
@interface HRViewController ()

@end

@implementation HRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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


- (IBAction)showInDetail:(UIButton *)sender {
    HRPopupConfiguration *config = [[HRPopupConfiguration alloc] init];
    config.queueEnable = YES;
    config.delayInterval = arc4random() % 2;
    config.showInterval = arc4random() % 3;
    config.whiteList = @[@"HRDetailViewController"];
    //    config.whiteList = @[NSStringFromClass(HRDetailViewController.class)];
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

- (UIColor*)RandomColor {
    
    NSInteger aRedValue =arc4random() %255;
    NSInteger aGreenValue =arc4random() %255;
    NSInteger aBlueValue =arc4random() %255;
    UIColor*randColor = [UIColor colorWithRed:aRedValue /255.0f
                                        green:aGreenValue /255.0f
                                         blue:aBlueValue /255.0f
                                        alpha:1.0f];
    
    return randColor;
    
}
@end
