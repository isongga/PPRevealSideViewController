//
//  LeftViewController.m
//  PPRevealSideViewController
//
//  Created by Marian PAUL on 16/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TableViewController.h"
#import "CustomCell.h"
#import "PopedViewController.h"
#import "MainViewController.h"
#import "SecondViewController.h"

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self.tableView addObserver:self 
                         forKeyPath:@"revealSideInset"
                            options:NSKeyValueObservingOptionNew
                            context:NULL];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"revealSideInset"]) {
        UIEdgeInsets newInset = self.tableView.contentInset;
        newInset.top = self.tableView.revealSideInset.top;
        newInset.bottom = self.tableView.revealSideInset.bottom;
        self.tableView.contentInset = newInset;
    }
    else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void) dealloc {
    [self.tableView removeObserver:self
                        forKeyPath:@"revealSideInset"];
#if !PP_ARC_ENABLED
    [super dealloc];
#endif
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CustomCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    switch (indexPath.row % 5) {
        case 0:
            cell.textLabel.text = @"Go to root";
            break;
        case 1:
            cell.textLabel.text = @"Push a new right";
            break; 
        case 2:
            cell.textLabel.text = @"Push new left";
            break;
        case 3:
            cell.textLabel.text = @"Pop new center";
            break;
        case 4:
            cell.textLabel.text = @"Pop main center";
            break;
        default:
            break;
    }
    cell.revealSideInset = self.tableView.revealSideInset;
    
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

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    switch (indexPath.row % 5) {
        case 0:
            [self.revealSideViewController popViewControllerAnimated:YES];
            break;
        case 1:
        {
            PopedViewController *c = [[PopedViewController alloc] initWithNibName:@"PopedViewController" bundle:nil];
            [self.revealSideViewController pushViewController:c
                                                  onDirection:PPRevealSideDirectionRight animated:YES];
            PP_RELEASE(c);
        }
            break; 
        case 2:
        {
            PopedViewController *c = [[PopedViewController alloc] initWithNibName:@"PopedViewController" bundle:nil];
            // Since we are in the left already, we force the pop then push
            [self.revealSideViewController pushViewController:c
                                                  onDirection:PPRevealSideDirectionLeft 
                                                     animated:YES
                                               forceToPopPush:YES];
            PP_RELEASE(c);
        }
            break;
        case 3:
        {
            SecondViewController *c = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
            [self.revealSideViewController popViewControllerWithNewCenterController:c 
                                                                           animated:YES];
            PP_RELEASE(c);
        }
            break;
        case 4:
        {
            MainViewController *c = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
            UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:c];
            [self.revealSideViewController popViewControllerWithNewCenterController:n 
                                                                           animated:YES];
            PP_RELEASE(c);
            PP_RELEASE(n);
        }            break;
        default:
            break;
    }
    
}

@end
