//
//  NSRunLoop+ExposureObserver.h
//  BankOfCommunications
//
//  Created by master@swiftdays.com on 2020/6/30.
//  Copyright © 2020 Swiftdays. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSRunLoop (ExposureObserver)

- (CFRunLoopObserverRef)lc_addObserverWith:(CFOptionFlags)activities repeats:(BOOL)repeats mode:(CFRunLoopMode)mode observerBlock:(void (^) (CFRunLoopObserverRef observer, CFRunLoopActivity activity))observerBlock;
- (CFRunLoopObserverRef)lc_addObserverForOnceWith:(CFOptionFlags)activities mode:(CFRunLoopMode)mode observerBlock:(void (^) (CFRunLoopObserverRef observer, CFRunLoopActivity activity))observerBlock;
- (CFRunLoopObserverRef)lc_addObserverWith:(CFOptionFlags)activities mode:(CFRunLoopMode)mode observerBlock:(void (^) (CFRunLoopObserverRef observer, CFRunLoopActivity activity))observerBlock;
- (CFRunLoopObserverRef)lc_addObserverWith:(CFOptionFlags)activities observerBlock:(void (^) (CFRunLoopObserverRef observer, CFRunLoopActivity activity))observerBlock;
- (CFRunLoopObserverRef)lc_addObserverForCommonModesWith:(CFOptionFlags)activities observerBlock:(void (^) (CFRunLoopObserverRef observer, CFRunLoopActivity activity))observerBlock;
- (CFRunLoopObserverRef)lc_addObserverWith:(void (^) (CFRunLoopObserverRef observer, CFRunLoopActivity activity))observerBlock;
- (CFRunLoopObserverRef)lc_addObserverForCommonModesWith:(void (^) (CFRunLoopObserverRef observer, CFRunLoopActivity activity))observerBlock;

- (void)lc_removeObserverWith:(CFRunLoopObserverRef)observer mode:(CFRunLoopMode)mode;
- (void)lc_removeObserverForCommonModesWith:(CFRunLoopObserverRef)observer;

@end

NS_ASSUME_NONNULL_END
