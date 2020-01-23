//
//  ShoppingViewController.m
//  foodie
//
//  Created by Aakash Bista on 13/1/20.
//  Copyright © 2020 Aakash Bista. All rights reserved.
//

#import "ShoppingViewController.h"

@interface ShoppingViewController ()

@end

@implementation ShoppingViewController

@synthesize listOfIngredients;


- (void)viewDidLoad {
    [super viewDidLoad];
     self.ref = [[FIRDatabase database] reference];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
      [self loadIngredients];
   
}

-(void)loadIngredients{
    self.listOfIngredients=NSMutableArray.new;
    FIRDatabaseQuery *getIngredientsListQuery = [[self.ref child:@"Foodie/Shopping"] queryOrderedByKey];
    [getIngredientsListQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
           NSLog(@"%@",snapshot.value);
        NSLog(@"%lu",(unsigned long)[snapshot.value count]);
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *child;
            while (child = [children nextObject]) {
              //  NSString* key=child.value;
               //[self getListOfIngredients:key];
            }
    }];
   
}

-(void)getListOfIngredients :(NSString *) key {
   
    listOfIngredients=NSMutableArray.new;
    Ingredients *ingredient=Ingredients.new;
    FIRDatabaseQuery *getIngredients = [[[self.ref child:@"Foodie/Ingredient/"] queryOrderedByKey] queryEqualToValue:key];
    [getIngredients observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
      // NSLog(@"%@",[snapshot.children nextObject]);
        NSArray* value  =[[snapshot.children nextObject] value];
            for (int i=0; i<value.count; i++) {
                [ingredient  setTitle:[[value objectAtIndex:i] objectForKey:@"title"]];
                [self.listOfIngredients addObject:ingredient];
                  NSLog(@" list of: %@",ingredient.title );
                 [self.tableView reloadData];
            }
        }];
    
    
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label=  UILabel.new;
    label.text=@"Header";
    label.backgroundColor=UIColor.grayColor;
    return label;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.listOfIngredients.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shoppingListCell" forIndexPath:indexPath];
    Ingredients *ingredient=self.listOfIngredients[indexPath.row];
   cell.textLabel.text=ingredient.title;
      return cell;
   
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
