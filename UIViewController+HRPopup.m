//
//  UIViewController+HRPopup.m
//  HRPopup
//
//  Created by Gavin on 2020/3/25.
//

#import "UIViewController+HRPopup.h"
#import "HRPopupManager.h"
#import <objc/runtime.h>
static char deallocKey;
@implementation  UIViewController(HRPopup)
+ (void)load {
    hr_swizzling_exchangeMethod([self class],
                                @selector(viewDidAppear:),
                                @selector(hr_popup_viewDidAppear:));
    hr_swizzling_exchangeMethod([self class],
                                @selector(viewWillDisappear:),
                                @selector(hr_popup_viewWillDisappear:));
    hr_swizzling_exchangeMethod([self class],
                                NSSelectorFromString(@"dealloc"),
                                @selector(hr_dealloc));
}

static inline void hr_swizzling_exchangeMethod(Class clazz, SEL originalSelector, SEL exchangeSelector) {
    // 获取原方法
    Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
    // 获取需要交换的方法
    Method exchangeMethod = class_getInstanceMethod(clazz, exchangeSelector);
    
    if (class_addMethod(clazz, originalSelector, method_getImplementation(exchangeMethod), method_getTypeEncoding(exchangeMethod))) {
        class_replaceMethod(clazz, exchangeSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, exchangeMethod);
    }
    
}

- (void)setHr_deallocHandler:(HRPopupDeallocHandler)hr_deallocHandler {
    objc_setAssociatedObject(self, &deallocKey, hr_deallocHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (HRPopupDeallocHandler)hr_deallocHandler {
    return objc_getAssociatedObject(self, &deallocKey);
}


- (void)hr_popup_viewDidAppear:(BOOL)animated {
    [self hr_popup_viewDidAppear:animated];
    @synchronized (self) {
        [HRPopupManager continueQueueWithObj:self];
        [HRPopupManager showPopupViewWaitDisplayWithVC:self];
    }
}

- (void)hr_popup_viewWillDisappear:(BOOL)animated {
    [self hr_popup_viewWillDisappear:animated];
    @synchronized (self) {
        [HRPopupManager suspendQueueWithObj:self];
    }
}
- (void)hr_dealloc {
    if (self.hr_deallocHandler) {
        self.hr_deallocHandler();
        self.hr_deallocHandler = nil;
    }
    [HRPopupManager canclAllOperationsWithVC:self];
    [self hr_dealloc];
}
@end
