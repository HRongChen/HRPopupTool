//
//  HRPopupManager.m
//  HRPopup
//
//  Created by Gavin on 2020/3/11.
//  Copyright © 2020 HRPopup. All rights reserved.
//

#import "HRPopupManager.h"
#import "HRPopupService.h"
#import "HRPopupConfiguration.h"
#import "HRPopupWindow.h"
#import <objc/runtime.h>

@interface HRPopupManager()
@property (nonatomic, strong) NSMutableArray<HRPopupService*> *services;//加入队列的服务
@property (nonatomic, strong) NSMutableArray<NSOperationQueue*> *queueList;//队列数组
@end

@implementation HRPopupManager
+ (instancetype)sharedManager {
    static HRPopupManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HRPopupManager alloc] init];
    });
    return manager;
}


+ (void)showWithConfiguration:(HRPopupConfiguration *)configuration
            completionHandler:(HRPopupExecuteHandler)executeHandler {
    HRPopupService *service = [[HRPopupService alloc] initWithConfiguration:configuration executeHandler:executeHandler];
    if (configuration.queueEnable) {
        [self processWithService:service];
    }else{
        [self progressWithUnlimitedService:service];
    }
}

+ (void)progressWithUnlimitedService:(HRPopupService *)service {
    if (service == nil){
        NSAssert(NO, @"啥都不传，你叫我做啥");
        return;
    }
    if (service.configuration.cancelCurrentShow) {
        [[UIApplication sharedApplication].windows enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[HRPopupWindow class]]) {
                HRPopupWindow *currentShowWindow = obj;
                currentShowWindow.rootViewController = nil;
                currentShowWindow.hidden = YES;
                currentShowWindow = nil;
                *stop = YES;
            }
        }];
        [service show];
    }else{
        [service show];
    }
}

+ (void)processWithService:(HRPopupService *)service {
    if (service == nil) {
        NSAssert(NO, @"啥都不传，你叫我做啥");
        return;
    }
    NSObject * obj =  service.configuration.currentController ?: [self getCurrentController];
    HRPopupManager * manager = [HRPopupManager sharedManager];
    //白名单检测
    NSArray * whiteList = service.configuration.whiteList;
    BOOL canCurrentShow = NO;
    if (whiteList.count <= 0) {
        canCurrentShow = YES;
    }else{
        for (NSString *whiteVCName in whiteList) {
            if ([obj isKindOfClass:NSClassFromString(whiteVCName)]) {
                canCurrentShow = YES;
                break;
            }
        }
    }
    //为YES,则检测通过 可显示，为no则检测失败 进入等待数组
    if (!canCurrentShow) {
        [manager.services addObject:service];
        return;
    }
    
    //存在检测，如果队列中已存在需要show的view则不显示
    BOOL isContain = NO;
    NSOperationQueue * queue = [manager getQueueWithObject:obj];
    for (HRPopupOperation * op in [queue operations]) {
        if ([op isEqual:service.operation]) {
            isContain = YES;
            break;
        }
    }
    //存在直接返回
    if (isContain) {
        return;
    }
    
    if (service.configuration.cancelCurrentShow) {
        [queue.operations enumerateObjectsUsingBlock:^(__kindof NSOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HRPopupOperation *item = obj;
            if ([item isExecuting]) {
                [item.currentService dismiss];
                *stop = YES;
            }
        }];
    }
    HRPopupOperation * op = [[HRPopupOperation alloc ]init];
    switch (service.configuration.showPriority) {
        case HRPopupShowPriorityNormal:
            op.queuePriority =  NSOperationQueuePriorityNormal;
            break;
        case HRPopupShowPriorityLow:
            op.queuePriority = NSOperationQueuePriorityLow;
            break;
        case HRPopupShowPriorityHight:
            op.queuePriority = NSOperationQueuePriorityHigh;
            break;
        case HRPopupShowPriorityVeryLow:
            op.queuePriority = NSOperationQueuePriorityVeryLow;
            break;
        case HRPopupShowPriorityVeryHight:
            op.queuePriority = NSOperationQueuePriorityVeryHigh;
            break;
    }
    service.operation = op;
    op.currentService = service;
    [queue addOperation:op];
    return;
}


#pragma 查询当前控制器是否有显示
+ (void)showPopupViewWaitDisplayWithVC:(UIViewController *)vc
{
    HRPopupManager * manager = [HRPopupManager sharedManager];
    NSString * vcClassName = NSStringFromClass([vc class]);
    NSMutableArray * didShowModels = [NSMutableArray array];
    for (HRPopupService * service in manager.services) {
        NSArray * values = service.configuration.whiteList;
        if (values.count <= 0) {
            [self processWithService:service];
            [didShowModels addObject:service];
        }else{
            for (NSString * vcName in values) {
                if ([vcName isEqualToString:vcClassName]) {
                    [self processWithService:service];
                    [didShowModels addObject:service];
                    break;
                }
            }
        }
    }
    [manager.services removeObjectsInArray:didShowModels];
    [didShowModels removeAllObjects];
}

+ (void)suspendQueueWithObj:(NSObject *)obj
{
    NSOperationQueue * queue = [[HRPopupManager sharedManager] findQueueWithObject:obj];
    queue.suspended = YES;
}

+ (void)continueQueueWithObj:(NSObject *)obj
{
    NSOperationQueue * queue = [[HRPopupManager sharedManager] findQueueWithObject:obj];
    queue.suspended = NO;
}

+ (void)canclAllOperationsWithVC:(UIViewController *)vc
{
    if (!vc) {
        return;
    }
    HRPopupManager * manager = [HRPopupManager sharedManager];
    NSOperationQueue * queue = [manager findQueueWithObject:vc];
    if (queue) {
        for (HRPopupOperation * op in [queue operations]) {
            if (!op.isFinished) {
                [op cancel];
            }
        }
        [manager.queueList removeObject:queue];
    }
}

- (NSOperationQueue *)getQueueWithObject:(NSObject *)obj
{
    NSString * key = [NSString stringWithFormat:@"%@+%p",NSStringFromClass([obj class]),obj];
    NSOperationQueue * queue = [self findQueueWithObject:obj];
    if (!queue) {
        queue = [[NSOperationQueue alloc] init];
        queue.name = key;
        queue.maxConcurrentOperationCount = 1;
        [self.queueList addObject:queue];
    }
    
    return queue;
}

- (nullable NSOperationQueue *)findQueueWithObject:(NSObject *)obj
{
    NSString * key = [NSString stringWithFormat:@"%@+%p",NSStringFromClass([obj class]),obj];
    NSOperationQueue * queue = nil;
    for (NSOperationQueue * tmpQ in self.queueList) {
        if ([tmpQ.name isEqualToString:key]) {
            queue = tmpQ;
            break;
        }
    }
    return queue;
}



- (NSMutableArray<NSOperationQueue *> *)queueList
{
    if (!_queueList) {
        _queueList = [NSMutableArray array];
    }
    return _queueList;
}

+ (UIViewController*)getCurrentController {
    UIViewController * rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarVC = (UITabBarController *)rootVC;
        UIViewController *presentVC = rootVC.presentedViewController;
        if (presentVC) {
            while (presentVC.presentedViewController) {
                presentVC = presentVC.presentedViewController;
            };
            if ([presentVC isKindOfClass:[UINavigationController class]]) {
                UINavigationController *nav = (UINavigationController *)presentVC;
                return nav.visibleViewController;
            }
            return presentVC;
        }
        UIViewController *selectedVC = tabBarVC.selectedViewController;
        if ([selectedVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)selectedVC;
            return nav.visibleViewController;
        }
        return tabBarVC.selectedViewController;
    }else if ([rootVC isKindOfClass:[UINavigationController class]]){
        UINavigationController *nav = (UINavigationController*)rootVC;
        return nav.visibleViewController;
    }else{
        return rootVC;
    }
}


- (NSMutableArray<HRPopupService*> *)services {
    if (!_services) {
        _services = [[NSMutableArray<HRPopupService*> alloc] init];
    }
    return _services;
}

@end


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
    [HRPopupManager canclAllOperationsWithVC:self];
    [self hr_dealloc];
}

@end
