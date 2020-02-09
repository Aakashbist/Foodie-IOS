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
        self.recipes=NSMutableArray.new;
}

-(void)loadFavourites{
    [self.recipes removeAllObjects];
    FIRDatabaseQuery *getFavouriteRecipesQuery = [[self.ref child:@"Foodie/Favourites"] queryOrderedByKey];
    [getFavouriteRecipesQuery observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        @try {
             NSEnumerator *children = [snapshot children];
                  FIRDataSnapshot *child;
                  if([children nextObject]){
                      while (child =[children nextObject] ) {

                          NSString* key=[child.value objectForKey:@"favourite"];
                           NSLog(@" key value: %@", key);
                              [self getListOfFavourite:key];

                      }
                  }
        } @catch (NSException *exception) {
          NSLog(@" catch exception%@", exception);
        }
      

    }];
   
    
}

-(void)getListOfFavourite:(NSString *) key
{
    if(key== NULL)
    {
         NSLog(@"key null true ");
    }
    if(key!= NULL)
    {
    
        FIRDatabaseQuery *getRecipesQuery = [[[self.ref child:@"Foodie/Recipes/"] queryOrderedByKey] queryEqualToValue:key];
        [getRecipesQuery observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            Recipe *recipe=Recipe.new;
            [recipe setRecipeTitle:[[snapshot.value objectForKey:key] objectForKey:@"title"]];
            [recipe setRecipeUrl:[[snapshot.value objectForKey:key]   objectForKey:@"url"]];
            [recipe setIngredient:[[snapshot.value objectForKey:key]   objectForKey:@"ingredient"]];
            [self.recipes addObject:recipe];
            [self.tableView reloadData];
            
        }];
    }
    
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recipes.count ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favouriteRecipeCell" forIndexPath:indexPath];
    Recipe *recipe=self.recipes[indexPath.row];
    cell.textLabel.text=recipe.recipeTitle;
    cell.imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:recipe.recipeUrl]]];
    return cell;
    
    
}



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
