//
//  UIViewController+Exposure.h
//  BankOfCommunications
//
//  Created by master@swiftdays.com on 2020/6/30.
//  Copyright © 2020 Swiftdays. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Exposure)
@property (nonatomic, assign, readonly) BOOL lc_viewDidAppeared;
@property (nonatomic, assign, readonly) BOOL lc_viewWillDisappeared;
@end

NS_ASSUME_NONNULL_END
