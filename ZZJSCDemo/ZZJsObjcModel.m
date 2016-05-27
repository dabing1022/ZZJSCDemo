//
//  ZZJsObjcModel.m
//  ZZJSCDemo
//
//  Created by ChildhoodAndy on 16/5/26.
//  Copyright © 2016年 ChildhoodAndy. All rights reserved.
//

#import "ZZJsObjcModel.h"

@implementation ZZJsObjcModel

- (void)jsCallSystemCamera
{
    NSLog(@"js call system camera");
    
    JSValue *jsFunc = self.context[@"jsFunc"];
    [jsFunc callWithArguments:nil];
}

- (void)showAlert:(NSString *)title msg:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [a show];
    });
}

- (void)callWithDict:(NSDictionary *)params
{
    NSLog(@"Js调用了OC的方法，参数为：%@", params);
}

- (void)jsCallObjcAndObjcCallJsWithDict:(NSDictionary *)params
{
    NSLog(@"jsCallObjcAndObjcCallJsWithDict was called, params is %@", params);
    
    // 调用JS的方法
    JSValue *jsParamFunc = self.context[@"jsParamFunc"];
    [jsParamFunc callWithArguments:@[@{@"age": @10, @"name": @"lili", @"height": @158}]];
}

@end
