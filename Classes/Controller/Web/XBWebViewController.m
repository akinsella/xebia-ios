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
#import "AFHTTPRequestOperation.h"
#import "XBHttpUtils.h"

@interface XBWebViewController()
    @property(nonatomic, assign)BOOL jsonLoaded;
@end

@implementation XBWebViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    self.jsonLoaded = NO;
    
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

- (void)setJson:(NSString *)json {
    self.jsonLoaded = NO;
    _json = json;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (!self.jsonLoaded) {
        self.navigationItem.rightBarButtonItem.enabled = self.shareInfo != nil;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    if (!self.jsonLoaded && self.json) {
        self.jsonLoaded = YES;
        NSLog(@"Finished loading");
        NSLog(@"json = %@",self.json);
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"onLoad(%@)", self.json]];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *requestString = [[request URL] absoluteString];

    if ([self requestIsLog:requestString]) {
        [self processLogRequest:requestString];
        return NO;
    }
    else {
        NSLog(@"Request String: %@", requestString);
        if ([self requestIsCid:requestString]) {
            [self processCidRequest:requestString];

            return NO;
        }
    }

    return YES;
}

- (void)processCidRequest:(NSString *)requestString {

    NSError *error;
    [self createCacheDirectoryIfMissing:&error];

    NSString *identifier = [self cidUrlIdentifier:requestString];
    NSString *resourcePath = [self resourcePathInCacheForRequestString:requestString];

    NSLog(@"Cid resourcePath: %@", resourcePath);
    if ([self fileExistInCacheForPath:resourcePath] ) {
        [self callResourceLoadedForPath:identifier path:resourcePath];
    }
    else {
        NSURL *resourceUrl = [self cidResourceUrl:requestString];
        NSLog(@"Try to download resource for url: '%@' and identifier: '%@'", resourceUrl, identifier);
        [XBHttpUtils downloadFileWithUrl:resourceUrl path:resourcePath
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"Downloaded resource with success: %@", responseObject);
                 [self callResourceLoadedForPath:identifier path:resourcePath];
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"Resource download error: %@", error);
                 [self removeCachedResourceForPath:resourcePath];

                 if ([self requestIsGravatar:requestString]) {
                     NSLog(@"Gravatar placeholder image sent");
                     [self callResourceLoadedForPath:identifier path:[self gravatarPlaceholder]];
                 }
                 else {
                     NSLog(@"Could not send placeholder image");
                 }
             }
        ];
    }
}

- (NSString *)gravatarPlaceholder {
    return [[NSBundle mainBundle] pathForResource:@"avatar_placeholder" ofType:@"png"];
}

- (void)processLogRequest:(NSString *)requestString {
    NSLog( @"*** %@", [self logFromRequest:requestString] );
}

- (void)callResourceLoadedForPath:(NSString *)identifier path:(NSString *)imagePath {
    NSString *jsCall = [self buildOnResourceLoadedJsCallWithIdentifier:identifier imagePath:imagePath];
    [self.webView stringByEvaluatingJavaScriptFromString:jsCall];
    NSLog(@"JS Call: %@", jsCall);
}

- (void)removeCachedResourceForPath:(NSString *)imagePath {
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
    }
}

- (NSString *)buildOnResourceLoadedJsCallWithIdentifier:(NSString *)identifier imagePath:(NSString *)imagePath {
    return [NSString stringWithFormat:@"onResourceLoaded('%@', '%@')", identifier, imagePath];
}

- (NSURL *)cidResourceUrl:(NSString *)requestString {
    BOOL isGravatar = [self requestIsGravatar:requestString];
    NSString *dataDecoded = [self cidUrlDataDecoded: requestString];

    return isGravatar ? [GravatarHelper getGravatarURL:dataDecoded] : [NSURL URLWithString:dataDecoded];
}

- (NSString *)resourcePathInCacheForRequestString:(NSString *)requestString {
    NSString *dataDecoded = [self cidUrlDataDecoded: requestString];
    NSString *cacheDirectory = [self cacheDirectory];

    BOOL isGravatar = [self requestIsGravatar:requestString];
    NSURL *resourceUrl = isGravatar ? [GravatarHelper getGravatarURL:dataDecoded] : [NSURL URLWithString:dataDecoded];

    NSString *resourceUrlExtension = isGravatar ? @"jpg" : [dataDecoded pathExtension];
    NSString *resourceUrlMd5 = [GravatarHelper getMd5:[resourceUrl absoluteString]];
    NSLog(@"Resource url : %@, MD5: %@", resourceUrl, resourceUrlMd5);
    return [cacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"cid-%@.%@", resourceUrlMd5, resourceUrlExtension]];
}

- (BOOL)requestIsGravatar:(NSString *)requestString {
    NSString *type = [self cidUrlType:requestString];
    return [type isEqualToString:@"gravatar"];
}

- (BOOL)fileExistInCacheForPath:(NSString *)imagePath {
    return [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
}

- (void)createCacheDirectoryIfMissing:(NSError **)error {
    NSString *cacheDirectory = [self cacheDirectory];

    BOOL isDir = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory isDirectory:&isDir] && isDir == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory withIntermediateDirectories:NO attributes:nil error:error];
    }
}

- (NSString *)cacheDirectory {
    NSString *globalCacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [globalCacheDirectory stringByAppendingPathComponent:@"WebViewCache"];
}

- (NSString *)logFromRequest:(NSString *)requestString {
    return [[requestString substringFromIndex:@"ios-log://".length] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)requestIsLog:(NSString *)requestString {
    return [requestString hasPrefix:@"ios-log://"];
}

- (BOOL)requestIsCid:(NSString *)requestString {
    return [requestString hasPrefix:@"cid://"];
}

- (NSString *)cidUrlPath:(NSString *)requestString {
    return [requestString substringFromIndex:[@"cid://" length]];
}

- (NSArray *)cidUrlParts:(NSString *)requestString {
    NSString *urlPath = [self cidUrlPath: requestString];
    return [urlPath componentsSeparatedByString: @"/"];
}

- (NSString *)cidUrlType:(NSString *)requestString {
    NSArray *cidUrlParts = [self cidUrlParts:requestString];
    return [cidUrlParts objectAtIndex: 0];
}

- (NSString *)cidUrlIdentifier:(NSString *)requestString {
    NSArray *cidUrlParts = [self cidUrlParts:requestString];
    return [cidUrlParts objectAtIndex: 1];
}

- (NSString *)cidUrlDataEncoded:(NSString *)requestString {
    NSArray *cidUrlParts = [self cidUrlParts:requestString];
    return [cidUrlParts objectAtIndex: 2];
}

- (NSString *)cidUrlDataDecoded:(NSString *)requestString {
    NSString *cidUrlDataEncoded = [self cidUrlDataEncoded:requestString];
    return [cidUrlDataEncoded stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
