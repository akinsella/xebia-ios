//
// Created by Alexis Kinsella on 07/08/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DTCoreText/DTLinkButton.h>
#import <DTCoreText/DTHTMLElement.h>
#import <DTCoreText/DTHTMLAttributedStringBuilder.h>
#import <DTCoreText/DTAttributedTextView.h>
#import "WPPostDetailsViewController.h"
#import "XBShareInfo.h"
#import "SHKItem.h"
#import "SHKActionSheet.h"
#import "NSDate+XBAdditions.h"
#import "UITableViewCell+VariableHeight.h"
#import "WPAbstractPostContentStructuredElementCell.h"

static NSString *kParagraphCellReuseIdentifier = @"paragraphCell";
static NSString *kDefaultCellReuseIdentifier = @"defaultCell";

NSString *kParagraphType = @"P";

@interface WPPostDetailsViewController ()
@property(nonatomic, strong)WPPost *post;
@property (nonatomic, strong) NSURL *lastActionLink;
@end

@implementation WPPostDetailsViewController

- (id)initWithPost:(WPPost *)post
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self = [sb instantiateViewControllerWithIdentifier:@"postDetails"];

    if (self) {
        self.post = post;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureView];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                           target:self
                                                                                           action:@selector(uiBarShareButtonItemHanderAction)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)configureView {
    self.titleLabel.text = self.post.titlePlain;
    self.dateLabel.text = [self.post.date formatDateOrTime];
    self.tagsLabel.text = self.post.tagsFormatted;
    self.categoryLabel.text = self.post.categoriesFormatted;
    self.authorLabel.text = self.post.authorFormatted;
    // TODO: Configure content
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    [self configureContentView];
}

- (void)uiBarShareButtonItemHanderAction {
    // Create the item to share (in this example, a url)
    XBShareInfo *shareInfo = [XBShareInfo shareInfoWithUrl:self.post.url title:self.post.title];

    NSURL *url = [NSURL URLWithString:shareInfo.url];
    SHKItem *item = [SHKItem URL:url title:shareInfo.title contentType: SHKURLContentTypeWebpage];

    // Get the ShareKit action sheet
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];

    // Display the action sheet
    [actionSheet showFromToolbar:self.navigationController.toolbar];
}

- (void)configureContentView {
//    self.tableView.backgroundColor = [UIColor colorWithHex:@"#191919" alpha:1.0];
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.contentTableView registerNib:[UINib nibWithNibName:@"WPPostContentDefaultElementCell" bundle:nil] forCellReuseIdentifier:@"defaultCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"WPPostContentParagraphElementCell" bundle:nil] forCellReuseIdentifier:@"paragraphCell"];

}



//
//- (void)configureContentView {
//
////    [DTCoreTextLayoutFrame setShouldDrawDebugFrames:YES];
//
//    self.contentTextView.attributedString = [self attributedStringForHTML:self.post.content];
//
//    self.contentTextView.contentInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
//
//    self.contentTextView.backgroundColor = [UIColor clearColor];
//
//    // we draw images and links via subviews provided by delegate methods
//    self.contentTextView.shouldDrawImages = NO;
//    self.contentTextView.shouldDrawLinks = NO;
//    self.contentTextView.textDelegate = self; // delegate for custom sub views
//
//    // set an inset. Since the bottom is below a toolbar inset by 44px
//
//    // gesture for testing cursor positions
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    [self.contentTextView addGestureRecognizer:tap];
//}
//
//
//#pragma mark Custom Views on Text
//
//- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame
//{
//    NSDictionary *attributes = [string attributesAtIndex:0 effectiveRange:NULL];
//
//    NSURL *URL = attributes[DTLinkAttribute];
//    NSString *identifier = attributes[DTGUIDAttribute];
//
//    DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
//    button.URL = URL;
//    button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
//    button.GUID = identifier;
//
//    // get image with normal link text
//    UIImage *normalImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDefault];
//    [button setImage:normalImage forState:UIControlStateNormal];
//
//    // get image for highlighted link text
//    UIImage *highlightImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDrawLinksHighlighted];
//    [button setImage:highlightImage forState:UIControlStateHighlighted];
//
//    // use normal push action for opening URL
//    [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
//
//    // demonstrate combination with long press
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
//    [button addGestureRecognizer:longPress];
//
//    return button;
//}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        [[UIApplication sharedApplication] openURL:[self.lastActionLink absoluteURL]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.post.structuredContent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPPostContentStructuredElement * structuredContentElement = self.post.structuredContent[indexPath.row];

    WPAbstractPostContentStructuredElementCell *cell;
    if ([structuredContentElement.type isEqualToString:kParagraphType]) {
        cell = [self.contentTableView dequeueReusableCellWithIdentifier:kParagraphCellReuseIdentifier];
    }
    else {
        cell = [self.contentTableView dequeueReusableCellWithIdentifier:kDefaultCellReuseIdentifier];
    }

    [cell updateWithWPPostContentElement: structuredContentElement];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell heightForCell];
}


//
//- (void)linkLongPressed:(UILongPressGestureRecognizer *)gesture
//{
//    if (gesture.state == UIGestureRecognizerStateBegan) {
//        DTLinkButton *button = (id)[gesture view];
//        button.highlighted = NO;
//        self.lastActionLink = button.URL;
//
//        if ([UIApplication.sharedApplication canOpenURL:button.URL.absoluteURL]) {
//            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:button.URL.absoluteURL.description delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", nil];
//            [action showFromRect:button.frame inView:button.superview animated:YES];
//        }
//    }
//}
//
//#pragma mark Actions
//
//- (void)linkPushed:(DTLinkButton *)button
//{
//    NSURL *URL = button.URL;
//
//    if ([UIApplication.sharedApplication canOpenURL:URL.absoluteURL]) {
//        [UIApplication.sharedApplication openURL:URL.absoluteURL];
//    }
//    else {
//        if (!URL.host && !URL.path) {
//            // possibly a local anchor link
//            NSString *fragment = URL.fragment;
//
//            if (fragment) {
//                [self.contentTextView scrollToAnchorNamed:fragment animated:NO];
//            }
//        }
//    }
//}
//
//#pragma mark - ContentView related stuff
//
//- (NSAttributedString *)attributedStringForHTML:(NSString *)html
//{
//    // Load HTML data
//    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
//
//    CGSize maxImageSize = CGSizeMake(self.view.bounds.size.width - 20.0, self.view.bounds.size.height - 20.0);
//
//    NSDictionary *options = @{
//            DTMaxImageSize: [NSValue valueWithCGSize:maxImageSize],
//            DTDefaultFontFamily: @"Helvetica",
//            DTDefaultFontSize: @14.0,
//            DTDefaultTextColor: [UIColor colorWithHex:@"#000000"],
//            DTDefaultLinkColor: @"purple",
//            DTDefaultLinkHighlightColor: @"red",
//            DTWillFlushBlockCallBack: ^(DTHTMLElement *element) {
//                XBLog(@"Element: %@", element.attributedString);
//            },
//            DTUseiOS6Attributes: @NO
//    };
//
//    DTHTMLAttributedStringBuilder*attributedStringBuilder = [[DTHTMLAttributedStringBuilder alloc] initWithHTML:data
//                                                                                                        options: options
//                                                                                             documentAttributes:nil];
//
//    NSAttributedString *attributedString = [attributedStringBuilder generatedAttributedString];
//
//    return attributedString;
//}
//
//- (void)handleTap:(UITapGestureRecognizer *)gesture
//{
//    if (gesture.state == UIGestureRecognizerStateRecognized)
//    {
//        CGPoint location = [gesture locationInView:self.contentTextView];
//        NSUInteger tappedIndex = (NSUInteger)[self.contentTextView closestCursorIndexToPoint:location];
//
//        NSString *plainText = [self.contentTextView.attributedString string];
//        NSString *tappedChar = [plainText substringWithRange:NSMakeRange(tappedIndex, 1)];
//
//        __block NSRange wordRange = NSMakeRange(0, 0);
//
//        [plainText enumerateSubstringsInRange:NSMakeRange(0, [plainText length]) options:NSStringEnumerationByWords usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
//            if (NSLocationInRange(tappedIndex, enclosingRange))
//            {
//                *stop = YES;
//                wordRange = substringRange;
//            }
//        }];
//
//        NSString *word = [plainText substringWithRange:wordRange];
//        NSLog(@"%d: '%@' word: '%@'", tappedIndex, tappedChar, word);
//    }
//}

@end