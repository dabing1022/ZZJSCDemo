//
//  ViewController.m
//  ZZJSCDemo
//
//  Created by ChildhoodAndy on 16/5/26.
//  Copyright © 2016年 ChildhoodAndy. All rights reserved.
//

#import "ViewController.h"
#import <JavascriptCore/JavascriptCore.h>
#import "ZZJsObjcModel.h"
#import "ViewController2.h"

/**
 *  @see https://developer.apple.com/videos/wwdc/2013/?id=615
 *  https://github.com/TomSwift/UIWebView-TS_JavaScriptContext
 *  https://hjgitbook.gitbooks.io/ios/content/04-technical-research/04-javascriptcore-note.html
 *  http://stackoverflow.com/questions/21714365/uiwebview-javascript-losing-reference-to-ios-jscontext-namespace-object?answertab=oldest#tab-top
 *  https://github.com/CoderJackyHuang/IOSCallJsOrJsCallIOS
 */

@protocol JSExport_ViewController <JSExport>

- (void)sayGoodbye;

@end

@interface ViewController () <UIWebViewDelegate, JSExport_ViewController> {
    @private
    JSContext *_context;
    UIWebView *_webView;
}

@property (nonatomic, weak) IBOutlet UIButton *nextControllerBtn;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:@"var num = 5 + 5"];
    [context evaluateScript:@"var times = function(value) { return value * 3 }"];
    JSValue *timesValue = [context evaluateScript:@"times(num)"];
    NSLog(@"timesValue %@, %@", timesValue, timesValue.toNumber);
    
    // exception
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"exception: %@", exception);
    };
    
    
    NSString *jsFilePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"js"];
    NSString *jsContent = [NSString stringWithContentsOfFile:jsFilePath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"---%@", [context evaluateScript:jsContent]);
    context[@"print"] = ^(NSString *text) {
        NSLog(@"print from js: %@", text);
    };
    
    JSValue *function = context[@"printHelloWorld"];
    [function callWithArguments:@[]];
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    NSString *url = [[NSBundle mainBundle] pathForResource:@"test2" ofType:@"html"];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]];
    [_webView loadRequest:req];
    
    [self.view bringSubviewToFront:self.nextControllerBtn];
    
    [self addNextButton];
}

- (void)addNextButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Next" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(self.view.bounds.size.width - 100, self.view.bounds.size.height - 100, 80, 80);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(gotoSecondaryPage:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)gotoSecondaryPage:(id)sender
{
    // 1. _webView load a new url request
    NSString *url = [[NSBundle mainBundle] pathForResource:@"test3" ofType:@"html"];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]];
    [_webView loadRequest:req];
    
    // 2. push a new view controller
//    UIViewController *viewController2 = [[ViewController2 alloc] init];
//    [self.navigationController pushViewController:viewController2 animated:YES];
}

- (void)sayGoodbye
{
    NSLog(@"say goodbye..");
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Goodbye, World!"
                                                        message: nil
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        
        [alert show];
    });
}

- (void)injectJSContext:(UIWebView *)webView
{
    _context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    ZZJsObjcModel *model = [[ZZJsObjcModel alloc] init];
    model.context = _context;
    model.webView = webView;
    _context[@"OCModel"] = model;
    
    _context[@"sayHello"] = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"sayHello"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
        });
    };
    
    _context[@"viewController"] = self;
    
    _context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        NSLog(@"异常信息：%@", exceptionValue);
    };
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

/**
 *  首先在UIWebView的webViewDidStartLoad阶段创建JSContext并暴露OC端的方法，在加载一级页面时JS正常调用OC的方法，而跳转到二级页面中却无法执行OC的方法；而在webViewDidStartLoad阶段由于并未加载完js文件，因此OC无法执行JS层定义的函数。
 *
 */
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"did start load");
    [self injectJSContext:webView];
}

/**
 *  在webVIewDidFinishLoad阶段创建JSContext并透出oc方法，由于加载js阶段在webVIewDidFinishLoad阶段之前，因此一级页面js无法调用oc方法，但是二级页面同理也是如此，但是由于js代码是在iOS的UI线程执行，因此为了让js可以调用oc方法，可以通过在js设置setTimeout来让任务放到执行队列的末端，先执行oc层的webVIewDidFinishLoad方法，待任务完成后再执行js中的异步代码，通过这种方式可以完成js调用oc方法；反过来，oc层调用js函数没有任何问题，因为在webVIewDidFinishLoad阶段js代码已执行完毕（除了异步代码）
 *
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"did finished");
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;
    
    [self injectJSContext:webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    
}

@end
