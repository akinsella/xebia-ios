//
//  PostViewControllerViewController.m
//  StoryboardUITableViewTutorial
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AuthorTableViewController.h"
#import "PostTableViewController.h"
#import "Author.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@implementation AuthorTableViewController {
    MBProgressHUD *HUD;
    NSMutableDictionary *sections;
}

@synthesize authors;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sections = [[NSMutableDictionary alloc] init];
    
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Loading";
	
	[HUD showWhileExecuting:@selector(updateAuthors) onTarget:self withObject:nil animated:YES];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)updateAuthors
{
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    
    [appDelegate updateAuthors];
    
    authors = appDelegate.authors;
    
    BOOL found;

    [sections removeAllObjects];
    
    // Loop through the books and create our keys
    for (Author *author in authors)
    {
        NSString *character = [[author name] substringToIndex:1];
        
        found = NO;
        
        for (NSString *section in [sections allKeys])
        {
            if ([section isEqualToString:character])
            {
                found = YES;
            }
        }
        
        if (!found)
        {
            [sections setValue:[[NSMutableArray alloc] init] forKey:character];
        }
    }
    
    // Loop again and sort the books into their respective keys
    for (Author *author in authors)
    {
        [[sections objectForKey:[[author name] substringToIndex:1]] addObject:author];
    }
    
    NSSortDescriptor *authorSort=[NSSortDescriptor sortDescriptorWithKey: @"name" ascending: YES selector: @selector(caseInsensitiveCompare:)];    

    // Sort each section array
    for (NSString *key in [sections allKeys])
    {
        [[sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:authorSort]];
    }
    
    [[self tableView] reloadData];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        PostTableViewController *postTableViewController = [segue destinationViewController];
        Author *author = [self.authors objectAtIndex:[self.tableView indexPathForSelectedRow].row];

        postTableViewController.identifier = author.identifier;
        postTableViewController.postType = AUTHOR;
        postTableViewController.title = [NSString stringWithFormat:@"%@'s posts", author.name];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return [[sections allKeys] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"AuthorCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: cellIdentifier];
    }
    
    Author *author = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		[self.authors removeObjectAtIndex:indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Author *author = [authors objectAtIndex:indexPath.row];
    
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
