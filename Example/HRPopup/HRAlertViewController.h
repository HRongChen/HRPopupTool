//
//  HRAlertViewController.h
//  HRPopup_Example
//
//  Created by Gavin on 2020/3/12.
//  Copyright © 2020 Gavin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HRAlertViewController : UIViewController

@property (nonatomic, copy)void(^dismiss)(void);
@property (nonatomic, copy)NSString *desc;
@end

NS_ASSUME_NONNULL_END
