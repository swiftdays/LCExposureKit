//
//  UIView+Exposure.h
//  BankOfCommunications
//
//  Created by master@swiftdays.com on 2020/6/30.
//  Copyright © 2020 Swiftdays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+ExposureExtend.h"
#import "LCExposureManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Exposure)
/**
     UIView 曝光时的操作（可用于统计）
 */
@property (nonatomic, copy, setter=lc_setExposuerBlock:) void(^lc_exposureBlock)(UIView *);

/**
    UIView 曝光补偿（设置采集设备忽略区域）
 */
@property (nonatomic, assign, setter=lc_setECompensationEdgeInsets:) UIEdgeInsets lc_ECompensationEdgeInsets;
@end

NS_ASSUME_NONNULL_END
