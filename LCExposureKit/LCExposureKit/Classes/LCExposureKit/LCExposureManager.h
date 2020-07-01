//
//  LCExposureManager.h
//  BankOfCommunications
//
//  Created by master@swiftdays.com on 2020/6/30.
//  Copyright © 2020 Swiftdays. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCExposureManager : NSObject

@property (nonatomic, strong, class, readonly) LCExposureManager *sharedManager;

//加入监听队列--但是未必就开始监听，只有对应控制器/uiwindow也处于展示状态才会监听
- (void)listenExposureView:(UIView *)view;
- (void)listenExposureViewController:(UIViewController *)VC;
- (void)dismissExposureViewController:(UIViewController *)VC;

- (NSInteger)getExposureViewTimesWithTDId:(NSString *)tdId;
- (void)setExposureWithTDId:(NSString*)tdId;
@end

NS_ASSUME_NONNULL_END
