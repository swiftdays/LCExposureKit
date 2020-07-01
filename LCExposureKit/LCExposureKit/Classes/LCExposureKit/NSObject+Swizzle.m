//
//  NSObject+Swizzle.m
//  BankOfCommunications
//
//  Created by master@swiftdays.com on 2020/6/30.
//  Copyright © 2020 Swiftdays. All rights reserved.
//

#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

@implementation NSObject (lcSwizzle)
+ (BOOL)lc_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError **)error_
{
    Method origMethod = class_getInstanceMethod(self, origSel_);
    if (!origMethod) {
        return NO;
    }
    Method altMethod = class_getInstanceMethod(self, altSel_);
    if (!altMethod) {
        return NO;
    }
    
    class_addMethod(self,
                    origSel_,
                    class_getMethodImplementation(self, origSel_),
                    method_getTypeEncoding(origMethod));
    class_addMethod(self,
                    altSel_,
                    class_getMethodImplementation(self, altSel_),
                    method_getTypeEncoding(altMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, origSel_), class_getInstanceMethod(self, altSel_));
    
    return YES;
}

+ (BOOL)lc_swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError **)error_
{
    return [object_getClass((id)self) lc_swizzleMethod:origSel_ withMethod:altSel_ error:error_];
}
@end

@implementation NSProxy (Swizzle)
+ (BOOL)lc_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError **)error_
{
    Method origMethod = class_getInstanceMethod(self, origSel_);
    if (!origMethod) {
        return NO;
    }
    Method altMethod = class_getInstanceMethod(self, altSel_);
    if (!altMethod) {
        return NO;
    }
    
    class_addMethod(self,
                    origSel_,
                    class_getMethodImplementation(self, origSel_),
                    method_getTypeEncoding(origMethod));
    class_addMethod(self,
                    altSel_,
                    class_getMethodImplementation(self, altSel_),
                    method_getTypeEncoding(altMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, origSel_), class_getInstanceMethod(self, altSel_));
    
    return YES;
}

+ (BOOL)lc_swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError **)error_
{
    return [object_getClass((id)self) lc_swizzleMethod:origSel_ withMethod:altSel_ error:error_];
}
@end
