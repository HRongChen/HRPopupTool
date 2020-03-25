//
//  HRPopupService.m
//  HRPopup
//
//  Created by Gavin on 2020/3/11.
//  Copyright © 2020 HRPopup. All rights reserved.
//

#import "HRPopupService.h"
#import "HRPopupWindow.h"
#import "HRPopupConfiguration.h"
#import "UIViewController+HRPopup.h"
@interface HRPopupService ()
@property (nonatomic, copy, nullable)HRPopupExecuteHandler executeHandler;
@end

@implementation HRPopupService

- (instancetype)initWithConfiguration:(HRPopupConfiguration *)configuration
                       executeHandler:(HRPopupExecuteHandler)executeHandler {
    self = [super init];
    if (self) {
        _executeHandler = executeHandler;
        _configuration = configuration;
    }
    return self;
}

- (void)show{
    if (self.configuration.showInterval > 0) {
        if ([self respondsToSelector:@selector(dismiss)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSelector:@selector(dismiss)
                           withObject:nil
                           afterDelay:self.configuration.showInterval];
            });
        }
    }
    
    _containerWindow = ({
        HRPopupWindow *window = [[HRPopupWindow alloc] initWithWindowLevel:self.configuration.windowLevel ?: UIWindowLevelStatusBar];
        window.backgroundColor = UIColor.clearColor;
        window;
    });
    _containerWindow.hidden = NO;
    UIViewController *vc = self.executeHandler(self);
    __weak typeof(self) weakSelf = self;
    vc.hr_deallocHandler = ^{
        [weakSelf.operation completion];
    };
    _containerWindow.rootViewController = vc;
}

- (void)dismiss {
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(dismiss)
                                               object:nil];
    _containerWindow.rootViewController = nil;
    _containerWindow.hidden = YES;
    _containerWindow = nil;
}




@end


@interface HRPopupOperation()

@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;

@end

@implementation HRPopupOperation

@synthesize finished = _finished;
@synthesize executing = _executing;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _executing = NO;
        _finished  = NO;
        self.queuePriority = NSOperationQueuePriorityVeryLow;
    }
    return self;
}

- (void)main {
    @autoreleasepool {
        if ([self isCancelled]) {
            self.finished = YES;
            return;
        }
        self.executing = YES;
        if (self.currentService.configuration.delayInterval > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSelector:@selector(show)
                           withObject:nil
                           afterDelay:self.currentService.configuration.delayInterval];
            });
        }else{
            [self show];
        }
    }
}

- (void)show{
    __weak typeof(self) weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (weakSelf.currentService) {
            [weakSelf.currentService show];
        }
    }];
}

- (void)completion{
    self.finished = YES;
}

- (void)cancel{
    if (self.isFinished) return;
    [super cancel];
}


#pragma mark -  手动触发 KVO
- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

@end
