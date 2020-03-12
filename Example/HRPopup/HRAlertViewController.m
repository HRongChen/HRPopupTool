//
//  HRAlertViewController.m
//  HRPopup_Example
//
//  Created by Gavin on 2020/3/12.
//  Copyright © 2020 Gavin. All rights reserved.
//

#import "HRAlertViewController.h"

@interface HRAlertViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation HRAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    self.contentView.backgroundColor = [self RandomColor];
    self.descLabel.text = _desc;
    self.contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}
- (IBAction)dismiss:(UIButton *)sender {
    if (self.dismiss) {
        self.dismiss();
    }
}

- (void)setDesc:(NSString *)desc {
    _desc = desc;
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
