//
//  UIView+Exposure.m
//  BankOfCommunications
//
//  Created by master@swiftdays.com on 2020/6/30.
//  Copyright © 2020 Swiftdays. All rights reserved.
//

#import "UIView+Exposure.h"
#import <objc/runtime.h>
#import "NSObject+Swizzle.h"
#import "UIView+Exposure.h"
#import "LCExposureManager.h"

@implementation UIView (lcExposure)

+ (void)load {
    [self lc_swizzleMethod:@selector(willMoveToWindow:) withMethod:@selector(lc_willMoveToWindow:) error:nil];
}

- (void)lc_willMoveToWindow:(UIWindow *)newWindow {
    [self lc_willMoveToWindow:newWindow];
    //加入或者移除监听
    if (self.lc_exposureBlock) {
        [[LCExposureManager sharedManager] listenExposureView:self];
    }
    if (!newWindow) {
        self.lc_viewController = nil;
    }
}

- (void)lc_setExposuerBlock:(void (^)(UIView *))lc_exposureBlock {
    [self willChangeValueForKey:NSStringFromSelector(@selector(lc_exposureBlock))];
    objc_setAssociatedObject(self, @selector(lc_exposureBlock), lc_exposureBlock, OBJC_ASSOCIATION_COPY);
    [self didChangeValueForKey:NSStringFromSelector(@selector(lc_exposureBlock))];
    //加入或者移除监听
    [[LCExposureManager sharedManager] listenExposureView:self];
}

- (void (^)(UIView *))lc_exposureBlock {
    return objc_getAssociatedObject(self, @selector(lc_exposureBlock));
}

- (void)lc_setECompensationEdgeInsets:(UIEdgeInsets)lc_ECompensationEdgeInsets {
    [self willChangeValueForKey:NSStringFromSelector(@selector(lc_ECompensationEdgeInsets))];
    if (UIEdgeInsetsEqualToEdgeInsets(lc_ECompensationEdgeInsets,UIEdgeInsetsZero)) {
        objc_setAssociatedObject(self, @selector(lc_ECompensationEdgeInsets), nil, OBJC_ASSOCIATION_RETAIN);
    } else {
        objc_setAssociatedObject(self, @selector(lc_ECompensationEdgeInsets), [NSValue valueWithUIEdgeInsets:lc_ECompensationEdgeInsets], OBJC_ASSOCIATION_COPY);
    }
    [self didChangeValueForKey:NSStringFromSelector(@selector(lc_ECompensationEdgeInsets))];
}

- (UIEdgeInsets)lc_ECompensationEdgeInsets {
    NSValue *ECompensationEdgeInsetsValue = objc_getAssociatedObject(self, @selector(lc_ECompensationEdgeInsets));
    if (ECompensationEdgeInsetsValue) {
        return ECompensationEdgeInsetsValue.UIEdgeInsetsValue;
    }
    return UIEdgeInsetsZero;
}

@end
