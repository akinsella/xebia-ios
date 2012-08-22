//
//  PostViewControllerViewController.m
//  Xebia Application
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "AuthorTableViewController.h"
#import "PostTableViewController.h"
#import "Author.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@implementation AuthorTableViewController

NSMutableDictionary *sections;
NSString *filterValue;

@synthesize authors, filteredAuthors, searchBar;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    filteredAuthors = [[NSMutableArray alloc] init];

    // ...Do initialization stuff here...

    searchBar.delegate = (id) self;

    sections = [[NSMutableDictionary alloc] init];

    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];

    HUD.delegate = self;
    HUD.labelText = @"Loading";

    [HUD showWhileExecuting:@selector(updateAuthors) onTarget:self withObject:nil animated:YES];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)text {
    filterValue = text;
    [self prepareData];
}

- (void)updateAuthors {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];


    [appDelegate updateAuthors];
    authors = appDelegate.authors;

    [self prepareData];
}

- (void)filterAuthors {
    [filteredAuthors removeAllObjects];

    for (Author *author in authors) {
        if (filterValue.length == 0) {
            [filteredAuthors addObject:author];
        }
        else {
            NSRange nameRange = [author.name rangeOfString:filterValue options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) {
                [filteredAuthors addObject:author];
            }
        }
    }

    NSLog(@"Authors found with filter: %@", filterValue);
    for (Author *author in filteredAuthors) {
        NSLog(@" * %@", author.name);
    }
}

- (void)prepareData {

    [self filterAuthors];

    BOOL found;

    [sections removeAllObjects];

    // Loop through the authors and create our keys
    for (Author *author in filteredAuthors) {
        NSString *character = [[author name] substringToIndex:1];

        found = NO;

        for (NSString *section in [sections allKeys]) {
            if ([section isEqualToString:character]) {
                found = YES;
            }
        }

        if (!found) {
            [sections setValue:[[NSMutableArray alloc] init] forKey:character];
        }
    }

    // Loop again and sort the books into their respective keys
    for (Author *author in filteredAuthors) {
        [[sections objectForKey:[[author name] substringToIndex:1]] addObject:author];
    }

    // Sort each section array
    for (NSString *key in [sections allKeys]) {
        [[sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[self sortDescriptorForAuthor]]];
    }

    [[self tableView] reloadData];

}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        PostTableViewController *postTableViewController = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Author *author = [self objectForSection:indexPath.section AtRow:indexPath.row];

        postTableViewController.identifier = author.identifier;
        postTableViewController.postType = AUTHOR;
        postTableViewController.title = [NSString stringWithFormat:@"%@'s posts", author.name];
    }
}


#pragma mark - Table view reusable methods

- (NSSortDescriptor *)sortDescriptorForAuthor {
    return [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];;
}

- (NSInteger)numberOfSectionsInTableView {
    return [[sections allKeys] count];
}

- (NSArray *)sortedSectionKeys {
    return [[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (NSString *)titleForHeaderInSection:(NSInteger)section {
    return [[self sortedSectionKeys] objectAtIndex:section];
}

- (id)sectionForIndex:(NSInteger)section {
    return [sections valueForKey:[[self sortedSectionKeys] objectAtIndex:section]];
}

- (id)objectForSection:(NSInteger)section AtRow:(NSInteger)row {
    return [[self sectionForIndex:section] objectAtIndex:row];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return [[self sectionForIndex:section] count];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numberOfSectionsInTableView];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self titleForHeaderInSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfRowsInSection:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AuthorCell";
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    Author *author = [self objectForSection:indexPath.section AtRow:indexPath.row];

    cell.textLabel.text = author.name;
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Author *author = [self objectForSection:indexPath.section AtRow:indexPath.row];

        [authors removeObject:author];
        [filteredAuthors removeObject:author];

        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

//    Author *author = [filteredAuthors objectAtIndex:indexPath.row];

//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:author.name 
//                                                    message:[NSString stringWithFormat:@"You selected '%@'", author.name] 
//                                                   delegate:nil 
//                                          cancelButtonTitle:nil 
//                                          otherButtonTitles:@"Ok", nil];
//    [alert show];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // Navigation logic may go here. Create and push another view controller.
    /*
     
     PostTableViewController *postTableViewController = [[PostTableViewController alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:postTableViewController animated:YES];
     */
}

@end
