//
//  ZZJsObjcModel.h
//  ZZJSCDemo
//
//  Created by ChildhoodAndy on 16/5/26.
//  Copyright © 2016年 ChildhoodAndy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavascriptCore/JavascriptCore.h>
#import <UIKit/UIKit.h>

@protocol JsObjcDelegate <JSExport>

- (void)jsCallSystemCamera;
- (void)showAlert:(NSString *)title msg:(NSString *)msg;
- (void)callWithDict:(NSDictionary *)params;
- (void)jsCallObjcAndObjcCallJsWithDict:(NSDictionary *)params;

@end

@interface ZZJsObjcModel : NSObject <JsObjcDelegate>

@property (nonatomic, weak) JSContext *context;
@property (nonatomic, weak) UIWebView *webView;

@end
