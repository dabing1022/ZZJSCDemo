//
//  ViewController2.m
//  ZZJSCDemo
//
//  Created by ChildhoodAndy on 16/5/26.
//  Copyright © 2016年 ChildhoodAndy. All rights reserved.
//

#import "ViewController2.h"
#import <JavascriptCore/JavascriptCore.h>

@protocol JSExport_ViewController2 <JSExport>

- (void)sayGoodbye;

@end

@interface ViewController2 () <UIWebViewDelegate, JSExport_ViewController2>

@end

@implementation ViewController2

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"ViewController2";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    [self.view addSubview:webView];
    NSString *url = [[NSBundle mainBundle] pathForResource:@"test3" ofType:@"html"];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]];
    [webView loadRequest:req];
}

- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)ctx
{
    ctx[@"sayHello"] = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Hello, World!"
                                                         message: nil
                                                        delegate: nil
                                               cancelButtonTitle: @"OK"
                                               otherButtonTitles: nil];
            
            [alert show];
        });
    };
    
    ctx[@"viewController"] = self;
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

@end
