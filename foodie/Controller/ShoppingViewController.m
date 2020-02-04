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

@synthesize listOfIngredients,ingredientTitle;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];
    self.listOfIngredients=NSMutableArray.new;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadIngredients];
    
}

-(void)loadIngredients{
    FIRDatabaseQuery *getIngredientsListQuery = [[self.ref child:@"Foodie/Shopping"] queryOrderedByKey];
    [getIngredientsListQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString* key=[snapshot.value objectForKey:@"ingredients"];
        NSString* title=[snapshot.value objectForKey:@"recipeTitle"];
        [self getListOfIngredientById:key : title];
    }];
}

-(void)getListOfIngredientById:(NSString *) key : (NSString *) title {
    FIRDatabaseQuery *getIngredients = [[[self.ref child:@"Foodie/Ingredient/"] queryOrderedByKey] queryEqualToValue:key];
    [getIngredients observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSArray* value  =[[snapshot.children nextObject] value];
        NSMutableArray* data= NSMutableArray.new;
        for (int i=0; i<value.count; i++) {
            self.ingredientTitle= [[value objectAtIndex:i] objectForKey:@"title"];
            [data addObject:self.ingredientTitle];
        }
        NSDictionary *post = @{
            @"title": title,
            @"ingredient":data
        };
        [self.listOfIngredients addObject:post];
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  
    CGRect frame = tableView.frame;
    
    UIButton *addButton = [[UIButton alloc] init];
    [addButton setTitle:@"×" forState:UIControlStateNormal];
    [addButton setTitleColor:UIColor.systemRedColor forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(removeIngredient) forControlEvents:UIControlEventTouchUpInside];
    addButton.frame=CGRectMake(frame.size.width-60, 5, 50, 20);
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
    
    title.text = [[self.listOfIngredients objectAtIndex:section ] objectForKey:@"title"];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [headerView addSubview:title];
    [headerView addSubview:addButton];
    
    headerView.backgroundColor=[UIColor colorWithRed:236.0f/255.0f
    green:236.0f/255.0f
     blue:236.0f/255.0f
    alpha:1.0f];
    
    return headerView;
}

-(void)removeIngredient{
    NSLog(@"%s@","clicked");
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listOfIngredients.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.listOfIngredients objectAtIndex:section ] objectForKey:@"ingredient"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shoppingListCell" forIndexPath:indexPath];
    cell.textLabel.text=[[self.listOfIngredients[indexPath.section] objectForKey:@"ingredient"] objectAtIndex:indexPath.row];
    return cell;
    
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }
//}


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
