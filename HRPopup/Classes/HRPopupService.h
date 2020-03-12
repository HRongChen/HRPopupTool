//
//  HRPopupService.h
//  HRPopup
//
//  Created by Gavin on 2020/3/11.
//  Copyright © 2020 HRPopup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRPopupTypeDeclaration.h"
@class HRPopupWindow;
@class HRPopupConfiguration;
@class HRPopupOperation;
NS_ASSUME_NONNULL_BEGIN

@interface HRPopupService : NSObject
- (instancetype)initWithConfiguration:(HRPopupConfiguration *)configuration
                       executeHandler:(HRPopupExecuteHandler)executeHandler;

@property (nonatomic, strong, readonly, nullable)HRPopupWindow *containerWindow;
///服务所需配置
@property (nonatomic, strong, readonly, nullable)HRPopupConfiguration *configuration;
///服务的操作单元
@property (nonatomic, weak, nullable)HRPopupOperation *operation;

- (void)show;
- (void)dismiss;
@end


@interface HRPopupOperation : NSOperation
@property (nonatomic, strong, nullable)HRPopupService *currentService;
- (void)completion;
@end
NS_ASSUME_NONNULL_END
