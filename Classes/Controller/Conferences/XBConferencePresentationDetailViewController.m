//
// Created by Simone Civetta on 22/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <SSToolkit/UIColor+SSToolkitAdditions.h>
#import "XBConferencePresentationDetailViewController.h"
#import "XBConferenceDownloader.h"
#import "XBConferencePresentationDataSource.h"
#import "XBConferencePresentationDetail.h"
#import "XBConferenceRatingViewController.h"
#import "UIColor+XBConferenceAdditions.h"

@interface XBConferencePresentationDetailViewController()
@property (nonatomic, strong) XBConferencePresentationDetail *presentationDetail;
@end

@implementation XBConferencePresentationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadConferenceDetail];
}

- (void)applyValues {
    self.title = self.presentationDetail.title;
    self.titleLabel.text = self.presentationDetail.title;
    self.summaryLabel.text = self.presentationDetail.summary;
    self.trackLabel.text = self.presentationDetail.track;
    self.speakerLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"by", @"by"), self.presentationDetail.speakerString];

    if (self.presentationDetail.fromTime) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale autoupdatingCurrentLocale];
        
        dateFormatter.dateFormat = @"EEEE dd LLLL";
        NSString *day = [dateFormatter stringFromDate:self.presentationDetail.fromTime];
        
        dateFormatter.dateFormat = @"HH'h'mm";
        NSString *from = [dateFormatter stringFromDate:self.presentationDetail.fromTime];
        NSString *to = [dateFormatter stringFromDate:self.presentationDetail.toTime];
        
        self.timeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ from %@ to %@", @"%@ from %@ to %@"), day, from, to];
    } else {
        self.timeLabel.text = nil;
    }
    
    [self.ratingButton setTitle:NSLocalizedString(@"Rate this", @"Rate this") forState:UIControlStateNormal];
    [self.ratingButton setBackgroundColor:[UIColor colorWithRed:0.416 green:0.125 blue:0.373 alpha:1]];
    self.ratingButton.layer.cornerRadius = 3.0;

    CALayer *colorLayer = [[CALayer alloc] init];
    colorLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 6);
    colorLayer.backgroundColor = [UIColor colorWithTrackIdentifier:self.presentationDetail.track].CGColor;
    [self.scrollView.layer addSublayer:colorLayer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.presentationDetail.canBeVoted) {
        self.ratingButton.hidden = NO;
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.5 animations:^{
            self.ratingButtonTopConstraint.constant = 20.0;
            [self.view layoutIfNeeded];
        }];
    }
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