//
//  UIView+ExposureExtend.h
//  BankOfCommunications
//
//  Created by master@swiftdays.com on 2020/6/30.
//  Copyright © 2020 Swiftdays. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ExposureExtend)
@property (nonatomic, strong, setter=lc_setViewController:) UIViewController *lc_viewController;
@property (nonatomic, assign, readonly) CGFloat lc_displayedInScreen;
@end

NS_ASSUME_NONNULL_END
