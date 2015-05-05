//
//  WebViewController.m
//  HaierOven
//
//  Created by 刘康 on 15/1/15.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.titleText;
    
    NSString* encodingString = [self.webPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodingString]];
    [self.webView loadRequest:request];
    
    if (self.navigationController.viewControllers.count == 1) {
        UIButton* leftButton = [[UIButton alloc] init];
        
        [leftButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        //[super setLeftBarButtonItemWithImageName:@"back.png" andTitle:nil andCustomView:leftButton];
        [super setLeftBarButtonItemWithImageName:nil andTitle:@"关闭" andCustomView:leftButton];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:AdButtonShouldShowNotification object:nil];
    }];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _loadingIndicator.hidden = NO;
    [_loadingIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _loadingIndicator.hidden = YES;
    [_loadingIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    _loadingIndicator.hidden = YES;
    [_loadingIndicator stopAnimating];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
