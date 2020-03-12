//
//  HRPopupConfiguration.h
//  HRPopup
//
//  Created by Gavin on 2020/3/11.
//  Copyright © 2020 HRPopup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HRPopupShowPriority) {
    HRPopupShowPriorityVeryLow,
    HRPopupShowPriorityLow,
    HRPopupShowPriorityNormal,
    HRPopupShowPriorityHight,
    HRPopupShowPriorityVeryHight
};


@interface HRPopupConfiguration : NSObject
@property (nonatomic, assign) HRPopupShowPriority showPriority;///显示优先级
@property (nonatomic, assign) NSTimeInterval delayInterval;///延迟时间或者间隔时间
@property (nonatomic, assign) NSTimeInterval showInterval;///弹窗显示时间
@property (nonatomic, assign) BOOL cancelCurrentShow;///是否取消当前正在显示的
@property (nonatomic, assign) UIWindowLevel windowLevel;///窗口覆盖等级
@property (nonatomic, assign) BOOL queueEnable;///是否进入队列，默认为YES
@property (nonatomic, readonly, weak)UIViewController *currentController;

///页面最终显示的页面为白名单 或者 除黑名单之外的页面 如果都没有则默认全部页面
@property (nonatomic, copy)NSArray<NSString *> *whiteList;///特定显示页面 有值则为特定页面，无值则任何页面
@end

NS_ASSUME_NONNULL_END
