//
//  UIView+Hieracrchy.m
//  BlackHorseHookDylib
//
//  Created by AiJe on 2018/9/25.
//  Copyright © 2018年 AiJe. All rights reserved.
//

#import "UIView+Hieracrchy.h"

@implementation UIView (Hieracrchy)

- (UIViewController *)viewContainingController {
    UIResponder *nextResponder = self;
    do {
        nextResponder = [nextResponder nextResponder];

        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController *)nextResponder;

    } while (nextResponder);

    return nil;
}

@end
