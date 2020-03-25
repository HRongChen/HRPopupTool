//
//  HRPopupTypeDeclaration.h
//  HRPopup
//
//  Created by Gavin on 2020/3/11.
//  Copyright © 2020 HRPopup. All rights reserved.
//
#import <UIKit/UIKit.h>
@class HRPopupService;

typedef UIViewController*_Nonnull(^HRPopupExecuteHandler)(HRPopupService *_Nullable service);
typedef void(^HRPopupDeallocHandler)(void);
