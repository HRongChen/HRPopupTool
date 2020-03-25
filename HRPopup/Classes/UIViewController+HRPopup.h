//
//  UIViewController+HRPopup.h
//  HRPopup
//
//  Created by Gavin on 2020/3/25.
//
#import <UIKit/UIKit.h>
#import "HRPopupManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (HRPopup)
@property (nonatomic, copy, nullable) HRPopupDeallocHandler hr_deallocHandler;
@end

NS_ASSUME_NONNULL_END
