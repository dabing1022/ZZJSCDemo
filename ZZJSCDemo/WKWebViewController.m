//
//  WKWebViewController.m
//  ZZJSCDemo
//
//  Created by ChildhoodAndy on 16/5/27.
//  Copyright © 2016年 ChildhoodAndy. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
#import <JavascriptCore/JavascriptCore.h>

#define DebugMethod() NSLog(@"%s", __func__)

@interface ScriptHandlerObject : NSObject <WKScriptMessageHandler>

@end

@implementation ScriptHandlerObject

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    [self logMessage:message];
    // We can do different things here by message's name
}

- (void)logMessage:(WKScriptMessage *)message {
    NSLog(@"Script msg name: %@", message.name);
    NSLog(@"Script msg body: %@", message.body);
    NSLog(@"Script msg frameInfo: %@", message.frameInfo);
}

@end

@interface WKWebViewController () <WKNavigationDelegate, WKUIDelegate>
{
    @private
    WKWebView *_webView;
    JSContext *_jsContext;
}

@end

@implementation WKWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences.minimumFontSize = 15.0f;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    config.userContentController = [[WKUserContentController alloc] init];
    ScriptHandlerObject *handlerObj = [[ScriptHandlerObject alloc] init];
    
    // @see test4.html window.webkit.messageHandlers.<name>.postMessage(message)
    [config.userContentController addScriptMessageHandler:handlerObj name:@"native"];
    [config.userContentController addScriptMessageHandler:handlerObj name:@"bb_share"];
    
    // 改变 `<h1>WKWebView Test</h1>`颜色
    WKUserScript *script = [[WKUserScript alloc] initWithSource:@"redHeader()" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    [config.userContentController addUserScript:script];
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test4" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:htmlString baseURL:nil];
    [self.view addSubview:_webView];
}

#pragma mark # - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    DebugMethod();
    NSLog(@"navigationAction type %@", @(navigationAction.navigationType));  // -1 WKNavigationTypeOther
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    DebugMethod();
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    DebugMethod();
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    DebugMethod();
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    DebugMethod();
//    _jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    NSLog(@"JSContext: %@", _jsContext);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    DebugMethod();
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    DebugMethod();
}

#pragma mark # - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    completionHandler();
    if (message.length > 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: message
                                                        message: nil
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        
        [alert show];
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
    
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    
}

@end
