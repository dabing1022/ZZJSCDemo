//
//  RootTableViewController.m
//  ZZJSCDemo
//
//  Created by ChildhoodAndy on 16/5/27.
//  Copyright © 2016年 ChildhoodAndy. All rights reserved.
//

#import "RootTableViewController.h"
#import "ViewController.h"
#import "ViewController2.h"
#import "WKWebViewController.h"

@interface RootTableViewController ()

@end

@implementation RootTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"JavascriptCoreDemo";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"demoCellReuseId"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"demoCellReuseId" forIndexPath:indexPath];
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"Way01. get JSContext from UIWebView";
            break;
        case 1:
            cell.textLabel.text = @"Way02. get JSContext from UIWebView";
            break;
        case 2:
            cell.textLabel.text = @"WKWebView";
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = nil;
    switch (indexPath.row) {
        case 0:
            vc = [[ViewController alloc] init];
            break;
        case 1:
            vc = [[ViewController2 alloc] init];
            break;
        case 2:
            vc = [[WKWebViewController alloc] init];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
