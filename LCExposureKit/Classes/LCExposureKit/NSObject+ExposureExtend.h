//
//  NSObject+ExposureExtend.h
//  BankOfCommunications
//
//  Created by master@swiftdays.com on 2020/6/30.
//  Copyright © 2020 Swiftdays. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UIViewController;

@interface NSObject (ExposureExtend)
- (UIViewController *)topViewController;
- (UIViewController *)topViewController:(UIViewController *)rootViewController;
@end

NS_ASSUME_NONNULL_END
