//
//  UIViewController+Exposure.m
//  BankOfCommunications
//
//  Created by master@swiftdays.com on 2020/6/30.
//  Copyright © 2020 Swiftdays. All rights reserved.
//

#import "UIViewController+Exposure.h"
#import "NSObject+Swizzle.h"
#import <objc/runtime.h>
#import "LCExposureManager.h"

@interface UIViewController()
@property (nonatomic, assign, setter=lc_setViewDidAppeared:) BOOL lc_viewDidAppeared;
@property (nonatomic, assign, setter=lc_setViewWillDisappeared:) BOOL lc_viewWillDisappeared;
@end
@implementation UIViewController (Exposure)
+ (void)load {
    [self lc_swizzleMethod:@selector(viewWillDisappear:) withMethod:@selector(lc_viewWillDisappear:) error:nil];
    [self lc_swizzleMethod:@selector(viewDidAppear:) withMethod:@selector(lc_viewDidAppear:) error:nil];
}

- (void)lc_viewDidAppear:(BOOL)animated {
    [self lc_viewDidAppear:animated];
    self.lc_viewDidAppeared = YES;
    [[LCExposureManager sharedManager] listenExposureViewController:self];
}

- (void)lc_viewWillDisappear:(BOOL)animated {
    self.lc_viewWillDisappeared = YES;
    [self lc_viewWillDisappear:animated];
    [[LCExposureManager sharedManager] dismissExposureViewController:self];
}

- (BOOL)lc_viewWillDisappeared {
    return [objc_getAssociatedObject(self, @selector(lc_viewWillDisappeared)) boolValue];
}

- (void)lc_setViewWillDisappeared:(BOOL)lc_viewWillDisappeared {
    [self willChangeValueForKey:NSStringFromSelector(@selector(lc_viewWillDisappeared))];
    objc_setAssociatedObject(self, @selector(lc_viewWillDisappeared), @(lc_viewWillDisappeared), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:NSStringFromSelector(@selector(lc_viewWillDisappeared))];
}

- (BOOL)lc_viewDidAppeared {
    return [objc_getAssociatedObject(self, @selector(lc_viewDidAppeared)) boolValue];
}

- (void)lc_setViewDidAppeared:(BOOL)lc_viewDidAppeared {
    [self willChangeValueForKey:NSStringFromSelector(@selector(lc_viewDidAppeared))];
    objc_setAssociatedObject(self, @selector(lc_viewDidAppeared), @(lc_viewDidAppeared), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:NSStringFromSelector(@selector(lc_viewDidAppeared))];
}

@end
