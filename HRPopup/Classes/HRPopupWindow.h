//
//  HRPopupWindow.h
//  HRPopup
//
//  Created by Gavin on 2020/3/11.
//  Copyright © 2020 HRPopup. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^HRPopupWindowDismissHandler)(void);

@interface HRPopupWindow : UIWindow
- (instancetype)initWithWindowLevel:(UIWindowLevel)level;
@end

NS_ASSUME_NONNULL_END
