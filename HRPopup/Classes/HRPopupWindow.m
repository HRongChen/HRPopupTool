//
//  HRPopupWindow.m
//  HRPopup
//
//  Created by Gavin on 2020/3/11.
//  Copyright © 2020 HRPopup. All rights reserved.
//

#import "HRPopupWindow.h"

@implementation HRPopupWindow

- (instancetype)initWithWindowLevel:(UIWindowLevel)level {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.windowLevel = level;
        self.hidden = YES;
    }
    return self;
}

@end
