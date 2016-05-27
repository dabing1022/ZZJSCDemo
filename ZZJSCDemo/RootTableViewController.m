//
//  RootTableViewController.m
//  ZZJSCDemo
//
//  Created by ChildhoodAndy on 16/5/27.
//  Copyright © 2016年 ChildhoodAndy. All rights reserved.
//

#import "RootTableViewController.h"
#import "ViewController.h"
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"demoCellReuseId" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"UIWebView";
    } else {
        cell.textLabel.text = @"WKWebView";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = nil;
    if (indexPath.row == 0) {
        vc = [[ViewController alloc] init];
    } else {
        vc = [[WKWebViewController alloc] init];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
