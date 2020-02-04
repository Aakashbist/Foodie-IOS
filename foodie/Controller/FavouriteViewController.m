//
//  FavouriteViewController.m
//  foodie
//
//  Created by Aakash Bista on 13/1/20.
//  Copyright © 2020 Aakash Bista. All rights reserved.
//

#import "FavouriteViewController.h"
#import "DetailViewController.h"

@interface FavouriteViewController ()
@end

@implementation FavouriteViewController

@synthesize recipes;

- (void)viewDidLoad {
    [super viewDidLoad];
        self.ref = [[FIRDatabase database] reference];
       
    
   
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
      [self loadFavourites];
}

-(void)loadFavourites{
     self.recipes=NSMutableArray.new;
    FIRDatabaseQuery *getFavouriteRecipesQuery = [[self.ref child:@"Foodie/Favourites"] queryOrderedByKey];
    [getFavouriteRecipesQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *child;
            while (child = [children nextObject]) {
            NSString* key=child.value;
                [self getListOfFavourite:key];
            }
    }];
    
}

-(void)getListOfFavourite:(NSString *) key
{
   FIRDatabaseQuery *getRecipesQuery = [[[self.ref child:@"Foodie/Recipes/"] queryOrderedByKey] queryEqualToValue:key];
          [getRecipesQuery observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
              Recipe *recipe=Recipe.new;              [recipe setRecipeTitle:[[snapshot.value objectForKey:key] objectForKey:@"title"]];
              [recipe setRecipeUrl:[[snapshot.value objectForKey:key]   objectForKey:@"url"]];
              [recipe setIngredient:[[snapshot.value objectForKey:key]   objectForKey:@"ingredient"]];
              [self.recipes addObject:recipe];
              [self.tableView reloadData];
          }];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   // NSLog(@"%lu  ,from log",(unsigned long)self.recipes.count);
    return self.recipes.count ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favouriteRecipeCell" forIndexPath:indexPath];
    Recipe *recipe=self.recipes[indexPath.row];
    cell.textLabel.text=recipe.recipeTitle;
    cell.imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:recipe.recipeUrl]]];
    return cell;
   
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([[segue identifier] isEqualToString:@"favouriteToDetailSeuge"]) {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            Recipe *choosenRecipe = [self.recipes objectAtIndex: indexPath.row];
            DetailViewController *detailViewController=segue.destinationViewController;
            detailViewController.currentRecipe=choosenRecipe;
        }
       
}


@end
