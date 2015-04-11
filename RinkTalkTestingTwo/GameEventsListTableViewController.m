//
//  GameEventsListTableViewController.m
//  RinkTalkTestingTwo
//
//  Created by Frank Avino on 4/6/15.
//  Copyright (c) 2015 Frank Avino. All rights reserved.
//

#import "GameEventsListTableViewController.h"
#import <Parse/Parse.h>

@interface GameEventsListTableViewController ()

@property (strong, nonatomic) NSMutableArray *eventsToShow;
@property (strong, nonatomic) NSMutableArray *eventTimesToShow;
@property (strong, nonatomic) NSMutableArray *eventRecordersToShow;


@end

@implementation GameEventsListTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.eventsToShow = [[NSMutableArray alloc] init];
    self.eventTimesToShow = [[NSMutableArray alloc] init];
    self.eventRecordersToShow = [[NSMutableArray alloc] init];
    [self loadEvents];
}

- (void)loadEvents
{
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query includeKey:@"submittedBy"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                //PFQuery *userQuery = [PFUser query];
                
                        PFObject *myGame = object[@"game"];

                        if(myGame.objectId == self.game.objectId){
                            //NSLog(@"We have found a game whose event we can display");
                            [self.eventsToShow addObject:object[@"type"]];
                            [self.eventTimesToShow addObject:object.createdAt];
                    
                            NSString *myUser = object[@"submittedBy"][@"username"];
                            NSLog(@"User: %@", myUser);
                            
                            [self.eventRecordersToShow addObject:myUser];
                            [self.tableView reloadData];
                            //NSLog(object[@"type"]);
                    
                        }
            }
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog(@"Number of rows: @%f", self.eventsToShow.count);

    
    return [self.eventsToShow count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"hh:mm:ss a"];
    [timeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"CST"]];
    NSString *newTime = [timeFormatter stringFromDate:[self.eventTimesToShow objectAtIndex:indexPath.row]];
    NSLog(@"%@ , ", newTime);
    newTime = [newTime stringByAppendingString:@" , "];
    NSString *detailLabel = [newTime stringByAppendingString:[self.eventRecordersToShow objectAtIndex:indexPath.row]];
    // Configure the cell...
    cell.textLabel.text = [self.eventsToShow objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = detailLabel;
    return cell;
}
@end
