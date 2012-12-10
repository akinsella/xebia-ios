//
//  XBWebViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 04/10/12.
//
//

#import "XBWebViewController.h"
#import "SHKItem.h"
#import "SHKActionSheet.h"
#import "UIColor+XBAdditions.h"
#import "GravatarHelper.h"
#import "SDWebImageManager.h"

@interface XBWebViewController ()

@end

@implementation XBWebViewController {
    UIBarButtonItem *uiBarShareButtonItem;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView setBackgroundColor:[UIColor colorWithHex:@"#141414"]];
    [self.webView setOpaque:NO];
    
    self.webView.delegate = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                          target:self
                                                                                          action:@selector(uiBarShareButtonItemHanderAction)];
}

- (void)uiBarShareButtonItemHanderAction {
	// Create the item to share (in this example, a url)
	NSURL *url = [NSURL URLWithString:self.shareInfo.url];
	SHKItem *item = [SHKItem URL:url title:self.shareInfo.title];
    
	// Get the ShareKit action sheet
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
	// Display the action sheet
	[actionSheet showFromToolbar:self.navigationController.toolbar];
}

- (void)webViewDidStartLoad:(UIWebView *)pWebView {
    NSLog(@"Started loading");
    self.navigationItem.rightBarButtonItem.enabled = self.shareInfo != nil;
}

- (void)webViewDidFinishLoad:(UIWebView *)pWebView {
    NSLog(@"Finished loading");
    
    NSError* error = nil;
    
    if (error) {
        NSLog(@"error = %@", [NSString stringWithFormat:@"Code[%i] %@" , error.code, error.description]);
    }
    
    if (self.json) {
        NSLog(@"json = %@",self.json);
        [pWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"onLoad(%@)", self.json]];
    }

}

- (BOOL)webView:(UIWebView *)webView2
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *requestString = [[request URL] absoluteString];
    NSLog(@"%@", requestString);
    
    if ([requestString hasPrefix:@"ios-log://"]) {
        
#ifdef DEBUG
        NSString* logText = [[requestString substringFromIndex:@"ios-log://".length] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog( @"UIWebController<%08x>: %@", (unsigned int)self, logText );
#endif
        
        return NO;
    }

    else if ([requestString hasPrefix:@"cid://"]) {
        NSString *urlPath = [requestString substringFromIndex:[@"cid://" length]];
        NSArray *urlPathParts = [urlPath componentsSeparatedByString: @"/"];
        NSString *type = [urlPathParts objectAtIndex: 0];
        NSString *identifier = [urlPathParts objectAtIndex: 1];
        NSString *dataEncoded = [urlPathParts objectAtIndex: 2];
        NSString *dataDecoded = [dataEncoded stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        BOOL isGravatar = [type isEqualToString:@"gravatar"];
        NSString *imageUrlExtension = isGravatar ? @"jpg" : [dataDecoded pathExtension];
        NSURL *imageURL = isGravatar ? [GravatarHelper getGravatarURL:dataDecoded] : [NSURL URLWithString:dataDecoded];
        
        NSLog(@"Try to download image for url: '%@' and identifier: '%@'", imageURL, identifier);

        NSLog(@"Image url : %@", imageURL);

        NSString *imageUrlMd5 = [GravatarHelper getMd5:[imageURL absoluteString]];

        NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/cid-%@.%@", imageUrlMd5, imageUrlExtension]];

        NSLog(@"Image path: %@", jpgPath);

        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:jpgPath];
        NSString *jsCall = [NSString stringWithFormat:@"onImageLoaded('%@', '%@')", identifier, jpgPath];

        if (fileExists) {
            NSLog(@"JS Call: %@", jsCall);
            [self.webView stringByEvaluatingJavaScriptFromString:jsCall];
        }
        else {
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadWithURL:imageURL
                            delegate:self
                             options:0 success:^(UIImage *image) {
                                NSLog(@"Image download with success: %@", image);
                                [UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
            
                                NSLog(@"JS Call: %@", jsCall);
                                [self.webView stringByEvaluatingJavaScriptFromString:jsCall];
                            }
                             failure:^(NSError *error) {
                                 NSLog(@"Image download error: %@", error);
                             }];
        }     

        return NO;
    }

    return YES;
}

- (void)imageCache:(SDImageCache *)imageCache didFindImage:(UIImage *)image forKey:(NSString *)key userInfo:(NSDictionary *)info {
    NSLog(@"Image downloaded: %@", imageCache);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
