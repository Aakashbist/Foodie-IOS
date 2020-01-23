//
//  RecipeViewController.m
//  foodie
//
//  Created by Aakash Bista on 7/1/20.
//  Copyright © 2020 Aakash Bista. All rights reserved.
//

#import "RecipeViewController.h"
#import "DetailViewController.h"


@interface RecipeViewController ()

    -(UIImage *) resize:(UIImage *)image toSize:(CGSize)size;
  

@end

@implementation RecipeViewController

@synthesize recipes,ingredients;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.ref = [[FIRDatabase database] reference];
    
    // Uncomment the following line to preserve selection between presentations.
   // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
      [self loadRecipes];
}

-(void)loadRecipes{
    FIRDatabaseQuery *getRecipesQuery = [[self.ref child:@"Foodie/Recipes"] queryOrderedByKey];
    self.recipes=NSMutableArray.new;
    [getRecipesQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        Recipe *recipe=Recipe.new;
        [recipe setRecipeId:snapshot.key];
        [recipe setRecipeTitle:[snapshot.value objectForKey:@"title"]];
        [recipe setRecipeUrl:[snapshot.value objectForKey:@"url"]];
        [recipe setIngredient:[snapshot.value objectForKey:@"ingredient"]];
        [self.recipes addObject:recipe];
   
        [self.tableView reloadData];
    }];
}

-(UIImage *) resize:(UIImage *)image toSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resizesImage=UIGraphicsGetImageFromCurrentImageContext();
    return resizesImage;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recipes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeCell" forIndexPath:indexPath];
   Recipe *recipe=self.recipes[indexPath.row];
   //NSLog(@"%@, %@",recipe.recipeTitle,recipe.recipeUrl);
    cell.textLabel.text=recipe.recipeTitle;
    cell.imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:recipe.recipeUrl]]];
    return cell;
}





#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Recipe *choosenRecipe = [self.recipes objectAtIndex: indexPath.row];
        DetailViewController *detailViewController=segue.destinationViewController;
        detailViewController.currentRecipe=choosenRecipe;
       }
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
