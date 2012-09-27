//
//  DetailViewController.m
//  StoryboardTutorial
//
//  Created by Kurry Tran on 10/20/11.
//  Copyright (c) 2011 Xebia France. All rights reserved.
//

#import "XBDetailPostViewController.h"
#import "WPPost.h"
#import "JSONKit.h" 

@implementation XBDetailPostViewController

@synthesize post, webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    [webView setBackgroundColor:[UIColor clearColor]];
    [webView setOpaque:NO];

    webView.delegate = self;

    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"www"];

    NSURL *htmlDocumentUrl = [NSURL fileURLWithPath:htmlFile];
    [webView loadRequest:[NSURLRequest requestWithURL:htmlDocumentUrl]];

}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"Started loading");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"Finshed loading");

    NSError* error = nil;

    NSString* json = @"{}"; //[[post getAsDictionary] JSONStringWithOptions:JKParseOptionNone error:&error];

    if (error != nil) {
        NSLog(@"error = %@", [NSString stringWithFormat:@"Code[%i] %@" , error.code, error.description]);
    }

    if (json != nil) {
        NSLog(@"json = %@",json);
    }

    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"onLoad(%@)", json]];
}

- (BOOL)webView:(UIWebView *)webView2
        shouldStartLoadWithRequest:(NSURLRequest *)request
                    navigationType:(UIWebViewNavigationType)navigationType {

    NSString *requestString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSLog(@"%@", requestString);

    if ([requestString hasPrefix:@"ios-log:"]) {

        #ifdef DEBUG
            NSString* logText = [[requestString substringFromIndex:@"ios-log://".length] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog( @"UIWebController<%08x>: %@", (unsigned int)self, logText );
        #endif

        return NO;

    }

    return YES;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
