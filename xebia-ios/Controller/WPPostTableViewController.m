//
//  WPPostTableViewController.m
//  Xebia Application
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPPostTableViewController.h"
#import "XBDetailPostViewController.h"
#import "AppDelegate.h"
#import "Date.h"

@implementation WPPostTableViewController


@synthesize identifier, postType, posts;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];

    HUD.delegate = self;
    HUD.labelText = @"Loading";

    [HUD showWhileExecuting:@selector(updatePosts) onTarget:self withObject:nil animated:YES];
}

- (void)updatePosts {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    [appDelegate updatePostsWithPostType:postType Id:identifier Count:100];

    posts = appDelegate.posts;

    [[self tableView] reloadData];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
      XBDetailPostViewController *detailPostViewController = [segue destinationViewController];
        Post *post = [self.posts objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        detailPostViewController.post = post;
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PostCell";
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    Post *post = [self.posts objectAtIndex:indexPath.row];

    cell.textLabel.text = post.title;
    cell.detailTextLabel.text = [Date formattedDateRelativeToNow:[Date parseDate: post.date withFormat: @"yyyy-MM-dd HH:mm:ss"]];

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.posts removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    Post *post = [posts objectAtIndex:indexPath.row];

//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:post.title 
//                                                    message:[NSString stringWithFormat:@"You selected '%@': %@", post.title, post.description] 
//                                                   delegate:nil 
//                                          cancelButtonTitle:nil 
//                                          otherButtonTitles:@"Ok", nil];
//    [alert show];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
