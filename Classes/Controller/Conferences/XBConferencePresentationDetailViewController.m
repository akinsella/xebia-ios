//
// Created by Simone Civetta on 22/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferencePresentationDetailViewController.h"
#import "XBConferenceDownloader.h"
#import "XBConferencePresentationDataSource.h"
#import "XBConferencePresentationDetail.h"
#import "XBConferenceRatingViewController.h"

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
    self.speakerLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"par", @"par"), self.presentationDetail.speakerString];
}

- (NSString *)pathForLocalDataSource {
    XBConferenceDownloader *downloader = [XBConferenceDownloader downloaderWithDownloadableBundle:self.conference];
    return [[downloader bundleFolderPath] stringByAppendingPathComponent:@"presentations"];
}

- (void)loadConferenceDetail {
    XBConferencePresentationDataSource *dataSource = [XBConferencePresentationDataSource dataSourceWithResourcePath:self.pathForLocalDataSource];
    [dataSource loadPresentationWithId:self.presentationIdentifier callback:^(XBConferencePresentationDetail *presentation) {
        self.presentationDetail = presentation;
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