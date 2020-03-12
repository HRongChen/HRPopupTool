//
//  HRPopupConfiguration.m
//  HRPopup
//
//  Created by Gavin on 2020/3/11.
//  Copyright © 2020 HRPopup. All rights reserved.
//

#import "HRPopupConfiguration.h"

@implementation HRPopupConfiguration
- (instancetype)init
{
    self = [super init];
    if (self) {
        _showPriority = HRPopupShowPriorityNormal;
        _delayInterval = 0;
        _showInterval = 0;
        _cancelCurrentShow = NO;
        _windowLevel = UIWindowLevelAlert;
        _queueEnable = YES;
    }
    return self;
}

@end
