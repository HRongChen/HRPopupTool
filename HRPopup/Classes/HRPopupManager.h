//
//  HRPopupManager.h
//  HRPopup
//
//  Created by Gavin on 2020/3/11.
//  Copyright © 2020 HRPopup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRPopupTypeDeclaration.h"

NS_ASSUME_NONNULL_BEGIN
@class HRPopupConfiguration;

@interface HRPopupManager : NSObject
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
+ (instancetype)allocWithZone:(struct _NSZone *)zone NS_UNAVAILABLE;



+ (instancetype)sharedManager;
+ (void)continueQueueWithObj:(NSObject *)obj;
+ (void)suspendQueueWithObj:(NSObject *)obj;
+ (void)canclAllOperationsWithVC:(UIViewController *)vc;
+ (void)showPopupViewWaitDisplayWithVC:(UIViewController *)vc;
+ (void)showWithConfiguration:(nullable HRPopupConfiguration *)configuration
            completionHandler:(HRPopupExecuteHandler)executeHandler;

@end

NS_ASSUME_NONNULL_END
