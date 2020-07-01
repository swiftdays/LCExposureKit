//
//  LCExposureManager.m
//  BankOfCommunications
//
//  Created by master@swiftdays.com on 2020/6/30.
//  Copyright © 2020 Swiftdays. All rights reserved.
//

#import "LCExposureManager.h"
#import "NSRunLoop+ExposureObserver.h"
#import "UIView+Exposure.h"
#import "UIView+ExposureExtend.h"
#import "NSObject+ExposureExtend.h"
#import "UIViewController+Exposure.h"

@interface LCExposureManager() {
    CFRunLoopObserverRef observer;
}
@property (nonatomic, strong) NSMutableDictionary *listenViewsExposureTimesDic;//记录曝光的次数
@property (nonatomic, strong) NSHashTable *listeningExposuredViews;//记录已经在曝光的视图
@property (nonatomic, strong) NSHashTable *listeningViews; //监听中
@property (nonatomic, strong) NSHashTable *listenableViews; //不符合监听条件，但是在监听列表中
@end

@implementation LCExposureManager

+ (instancetype)sharedManager {
    static id manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

#pragma mark -
- (instancetype)init {
    if (self = [super init]) {
        _listeningViews = [NSHashTable weakObjectsHashTable];
        _listenableViews = [NSHashTable weakObjectsHashTable];
        _listenViewsExposureTimesDic = [NSMutableDictionary dictionaryWithCapacity:0];
        _listeningExposuredViews = [NSHashTable weakObjectsHashTable];
        [self addApplicationObserver];
    }
    return self;
}

#pragma mark - observer run loop
- (void)addObserverForMainRunloop {
    if (observer || [UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        return;
    }
    __weak typeof(self) wSelf = self;
    observer = [[NSRunLoop mainRunLoop] lc_addObserverForCommonModesWith:kCFRunLoopBeforeWaiting observerBlock:^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        if (activity == kCFRunLoopBeforeWaiting) {//即将休眠，开始计算
            __strong typeof(wSelf) sSelf = wSelf;
            [sSelf pivate_runloop];
        }
    }];
}

- (void)removeObserverForMainRunloop {
    [[NSRunLoop mainRunLoop] lc_removeObserverForCommonModesWith:observer];
    observer = nil;
}

//退到后台就不进行监听了
- (void)addApplicationObserver {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if (self.listeningViews.count) {
            [self addObserverForMainRunloop];
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self removeObserverForMainRunloop];
    }];
}
#pragma mark - public
- (void)listenExposureView:(UIView *)view {
    if (view == nil) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!view.lc_exposureBlock) {
            [self pivate_removeExposureView:view];
        } else {
            [self pivate_listenExposureView:view];
        }
    });
}

- (void)listenExposureViewController:(UIViewController *)VC {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *listenables = self.listenableViews.allObjects;
        for (UIView *view in listenables) {
            if (view.lc_viewController == VC) {
                [self.listenableViews removeObject:view];
                [self.listeningViews addObject:view];
            }
        }
    });
}

- (void)dismissExposureViewController:(UIViewController *)VC {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *listenings = self.listeningViews.allObjects;
        for (UIView *view in listenings) {
            if (view.lc_viewController == VC) {
                [self.listeningViews removeObject:view];
                [self.listenableViews addObject:view];
            }
        }
    });
}

#pragma mark - private

- (CGFloat)pivate_exposureView:(UIView *)view {
    // 获取父视图控制器,判断父视图是否是当前显示的控制器
    UIViewController *vc = view.lc_viewController;
    if (!view || vc != [view topViewController]) {
        return 0;
    }
    if (!view.lc_exposureBlock) {
        return 0;
    }
    return view.lc_displayedInScreen;
}

- (void)pivate_listenExposureView:(UIView *)view_ {
//    到下一个runloop才加入曝光处理
    if (view_ == nil) {
        return;
    }
    UIView *listenView = view_;
    if ([self.listeningViews containsObject:listenView]) {
        if (!listenView.window || !listenView.lc_viewController.lc_viewDidAppeared) {
            [self.listeningViews removeObject:listenView];
            [self.listeningExposuredViews removeObject:listenView];
        }
    }
    if ([self.listenableViews containsObject:listenView]) {
        if (listenView.window && listenView.lc_viewController.lc_viewDidAppeared) {
            [self.listenableViews removeObject:listenView];
            [self.listeningExposuredViews removeObject:listenView];
        }
    }
    //      是否真的加入视图显示了
    if (listenView.window && listenView.lc_viewController.lc_viewDidAppeared) {
        [self.listeningViews addObject:listenView];
        if (self.listeningViews.count) {
            [self addObserverForMainRunloop];
        }
    } else { //将来被监听的视图
        [self.listenableViews addObject:listenView];
    }
}

- (void)pivate_removeExposureView:(UIView *)view_ {
    if (view_ == nil) {
        return;
    }
    [self.listeningViews removeObject:view_];
    [self.listenableViews removeObject:view_];
    [self.listeningExposuredViews removeObject:view_];
    
    if (self.listeningViews.count == 0) {
        [self removeObserverForMainRunloop];
    }
}

- (NSInteger)getExposureViewTimesWithTDId:(NSString *)tdId{
    NSInteger count = 0;
    NSNumber *countNum = [self.listenViewsExposureTimesDic valueForKey:tdId];
    if (countNum) {
        count = countNum.integerValue;
    }
    return count;
}
- (void)setExposureWithTDId:(NSString*)tdId{
    NSInteger count = [self getExposureViewTimesWithTDId:tdId];
    count++;
    [self.listenViewsExposureTimesDic setValue:@(count) forKey:tdId];
}

#pragma mark - runloop
- (void)pivate_runloop {
    NSArray *listenings = self.listeningViews.allObjects;
    for (UIView *view in listenings) {
        CGFloat percent = [self pivate_exposureView:view];
        if (percent >= 1) { //完全显示记录已曝光
            BOOL hasExposured = [self.listeningExposuredViews containsObject:view];
            if (view.lc_exposureBlock && !hasExposured) {
                view.lc_exposureBlock(view);
            }
            //并添加进入已曝光记录
            [self.listeningExposuredViews addObject:view];
        }else{//未完全显示从已曝光记录中移除
            [self.listeningExposuredViews removeObject:view];
        }
    }
}

@end

