//
//  UIView+ExposureExtend.m
//  BankOfCommunications
//
//  Created by master@swiftdays.com on 2020/6/30.
//  Copyright © 2020 Swiftdays. All rights reserved.
//

#import "UIView+ExposureExtend.h"
#import <objc/runtime.h>
#import "UIView+Exposure.h"

@implementation UIView (ExposureExtend)
- (UIViewController *)lc_viewController {
    // 响应链里的第一个uiviewcontroller
    UIViewController *vc = objc_getAssociatedObject(self, @"lc_viewController");
    if (vc == nil) {
        UIResponder *responder = self;
        while ((responder = [responder nextResponder])) {
            if ([responder isKindOfClass: [UIViewController class]]) {
                vc = (UIViewController *)responder;
                [self lc_setViewController:vc];
                break;
            }
        }
    }
    // 若没有，则返回nil
    return vc;
}

- (void)lc_setViewController:(UIViewController *)lc_viewController {
    objc_setAssociatedObject(self, @"lc_viewController", lc_viewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)lc_displayedInScreen {
    // 未添加到superview
    if (self.superview == nil) {
        return 0;
    }
    // view 隐藏
    if (self.hidden) {
        return 0;
    }
    // 转换view对应window的Rect
    CGRect rect = [self.superview convertRect:self.frame toView:nil];
    //如果可以滚动，清除偏移量
    if ([[self class] isSubclassOfClass:[UIScrollView class]]) {
        UIScrollView * scorll = (UIScrollView *)self;
        rect.origin.x += scorll.contentOffset.x;
        rect.origin.y += scorll.contentOffset.y;
    }
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect) || CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return 0;
    }
    // 获取 该view与window 交叉的 Rect windows需要减去设置的忽略区域
    CGRect screenRect = CGRectMake(self.lc_ECompensationEdgeInsets.left,self.lc_ECompensationEdgeInsets.top, [UIScreen mainScreen].bounds.size.width - self.lc_ECompensationEdgeInsets.left - self.lc_ECompensationEdgeInsets.right, [UIScreen mainScreen].bounds.size.height - self.lc_ECompensationEdgeInsets.top - self.lc_ECompensationEdgeInsets.bottom);
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return 0;
    }
    // 展示面积与实际面积的百分比
    CGFloat showPercent = intersectionRect.size.width * intersectionRect.size.height / (self.frame.size.width * self.frame.size.height);
    return showPercent;
}

@end

