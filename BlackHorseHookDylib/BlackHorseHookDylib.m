//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  BlackHorseHookDylib.m
//  BlackHorseHookDylib
//
//  Created by AiJe on 2018/9/25.
//  Copyright (c) 2018年 AiJe. All rights reserved.
//

#import "BlackHorseHookDylib.h"
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>
#import <Cycript/Cycript.h>
#import <MDCycriptManager.h>
#import "PluginSettingViewController.h"
#import "UIView+Hieracrchy.h"

CHConstructor{
    NSLog(INSERT_SUCCESS_WELCOME);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
#ifndef __OPTIMIZE__
        CYListenServer(6666);

        MDCycriptManager* manager = [MDCycriptManager sharedInstance];
        [manager loadCycript:NO];

        NSError* error;
        NSString* result = [manager evaluateCycript:@"UIApp" error:&error];
        NSLog(@"result: %@", result);
        if(error.code != 0){
            NSLog(@"error: %@", error.localizedDescription);
        }
#endif
        
    }];
}


CHDeclareClass(BHSettingTableView)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

//add new method
//CHDeclareMethod1(void, CustomViewController, newMethod, NSString*, output){
//    NSLog(@"This is a new method : %@", output);
//}

#pragma clang diagnostic pop

CHOptimizedMethod1(self, void, BHSettingTableView, reloadTableData, NSArray, *dataArray) {
    NSLog(@"Hook Method: %s", __func__);
    NSMutableArray *hookDataArray = [dataArray mutableCopy];
    [hookDataArray addObject:@"插件设置"];
    CHSuper1(BHSettingTableView, reloadTableData, [hookDataArray copy]);
}

CHOptimizedMethod2(self, void, BHSettingTableView, tableView, UITableView, *arg1, didSelectRowAtIndexPath, NSIndexPath, *indexPath) {
    NSLog(@"Hook Method: %s", __func__);
    if (indexPath.section == 0 && indexPath.row == 3) {
        PluginSettingViewController *setVc = [[PluginSettingViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:setVc];
        [arg1.viewContainingController presentViewController:navi animated:YES completion:nil];
    } else {
        CHSuper2(BHSettingTableView, tableView, arg1, didSelectRowAtIndexPath, indexPath);
    }
}

//CHOptimizedClassMethod0(self, void, CustomViewController, classMethod){
//    NSLog(@"hook class method");
//    CHSuper0(CustomViewController, classMethod);
//}
//
//CHOptimizedMethod0(self, NSString*, CustomViewController, getMyName){
//    //get origin value
//    NSString* originName = CHSuper(0, CustomViewController, getMyName);
//
//    NSLog(@"origin name is:%@",originName);
//
//    //get property
//    NSString* password = CHIvar(self,_password,__strong NSString*);
//
//    NSLog(@"password is %@",password);
//
//    [self newMethod:@"output"];
//
//    //set new property
//    self.newProperty = @"newProperty";
//
//    NSLog(@"newProperty : %@", self.newProperty);
//
//    //change the value
//    return @"AiJe";
//
//}

//add new property
//CHPropertyRetainNonatomic(CustomViewController, NSString*, newProperty, setNewProperty);

CHConstructor{
    CHLoadLateClass(BHSettingTableView);
    CHClassHook1(BHSettingTableView, reloadTableData);
    CHClassHook2(BHSettingTableView, tableView, didSelectRowAtIndexPath);
//    CHLoadLateClass(CustomViewController);
//    CHClassHook0(CustomViewController, getMyName);
//    CHClassHook0(CustomViewController, classMethod);
//
//    CHHook0(CustomViewController, newProperty);
//    CHHook1(CustomViewController, setNewProperty);
}

