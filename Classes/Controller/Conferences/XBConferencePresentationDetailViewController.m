//
// Created by Simone Civetta on 22/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XBConferencePresentationDetailViewController.h"
#import "XBConferenceDownloader.h"
#import "XBConferencePresentationDataSource.h"
#import "XBConferencePresentationDetail.h"
#import "XBConferenceRatingViewController.h"
#import "UIColor+XBConferenceAdditions.h"
#import "MMMarkdown.h"
#import "DTCoreTextConstants.h"
#import "NSAttributedString+HTML.h"
#import "UIColor+XBAdditions.h"

@interface XBConferencePresentationDetailViewController()
@property (nonatomic, strong) XBConferencePresentationDetail *presentationDetail;
@property (nonatomic, strong) CALayer *colorLayer;
@end

@implementation XBConferencePresentationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadConferenceDetail];
}

- (NSString *)trackPath {
    return [NSString stringWithFormat:@"/presentations/%@", self.presentation.presentationIdentifier];
}

- (void)applyValues {
    self.title = self.presentationDetail.title;
    self.titleLabel.text = self.presentationDetail.title;
    self.summaryLabel.text = self.presentationDetail.summary;
//
//    NSError *summaryError;
//    NSString *htmlSummaryString = [MMMarkdown HTMLStringWithMarkdown:self.presentationDetail.summary error:&summaryError];
//    if (summaryError) {
//        self.summaryLabel.text = self.presentationDetail.summary;
//    } else {
//        NSAttributedString *htmlSummaryAttributedString = [[NSAttributedString alloc] initWithHTMLData:[htmlSummaryString dataUsingEncoding:NSUTF8StringEncoding] options:@{DTUseiOS6Attributes: @(YES)} documentAttributes:NULL];
//        self.summaryLabel.attributedText = htmlSummaryAttributedString;
//    }

    self.trackLabel.text = self.presentationDetail.track;
    self.speakerLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"by", @"by"), self.presentationDetail.speakerString];

    if (self.presentationDetail.fromTime) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale autoupdatingCurrentLocale];
        
        dateFormatter.dateFormat = @"EEEE dd LLLL";
        NSString *day = [[dateFormatter stringFromDate:self.presentationDetail.fromTime] capitalizedString];
        
        dateFormatter.dateFormat = @"HH'h'mm";
        NSString *from = [dateFormatter stringFromDate:self.presentationDetail.fromTime];
        NSString *to = [dateFormatter stringFromDate:self.presentationDetail.toTime];
        
        self.timeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ from %@ to %@", @"%@ from %@ to %@"), day, from, to];
    } else {
        self.timeLabel.text = nil;
    }
    
    [self.ratingButton setTitle:NSLocalizedString(@"Rate this", @"Rate this") forState:UIControlStateNormal];
    [self.ratingButton setBackgroundColor:[UIColor xebiaPurpleColor]];
    self.ratingButton.layer.cornerRadius = 3.0;

    CALayer *colorLayer = [[CALayer alloc] init];
    colorLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 6);
    colorLayer.backgroundColor = [UIColor colorWithTrackIdentifier:self.presentationDetail.track].CGColor;
    self.colorLayer = colorLayer;
    [self.scrollView.layer addSublayer:colorLayer];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.colorLayer.frame = CGRectMake(0, 0, CGRectGetHeight(self.navigationController.view.frame), 6);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    if (self.presentationDetail.canBeVoted) {
//        self.ratingButton.hidden = NO;
//        [self.view layoutIfNeeded];
//        [UIView animateWithDuration:0.5 animations:^{
//            self.ratingButtonTopConstraint.constant = 20.0;
//            [self.view layoutIfNeeded];
//        }];
//    }
}

- (NSString *)pathForLocalDataSource {
    XBConferenceDownloader *downloader = [XBConferenceDownloader downloaderWithDownloadableBundle:self.conference];
    return [[downloader bundleFolderPath] stringByAppendingPathComponent:@"presentations"];
}

- (void)loadConferenceDetail {
    XBConferencePresentationDataSource *dataSource = [XBConferencePresentationDataSource dataSourceWithResourcePath:self.pathForLocalDataSource];
    [dataSource loadPresentationWithId:self.presentation.presentationIdentifier callback:^(XBConferencePresentationDetail *presentation) {
        self.presentationDetail = presentation;
        [self.presentationDetail mergeWithPresentation:self.presentation];
        [self applyValues];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowVoteForm"]) {
        XBConferenceRatingViewController *vc = segue.destinationViewController;
        vc.presentationDetail = self.presentationDetail;
    }
}

@end