//
//  RecipeViewController.m
//  foodie
//
//  Created by Aakash Bista on 7/1/20.
//  Copyright © 2020 Aakash Bista. All rights reserved.
//

#import "RecipeViewController.h"
#import "DetailViewController.h"
#import "AddRecipeViewController.h"


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
    
    // Use the current view controller to update the search results.
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:self];
    // Use the current view controller to update the search results.
    searchController.searchResultsUpdater = self;
    // Install the search bar as the table header.
    self.navigationItem.titleView = searchController.searchBar;
    // It is usually good to set the presentation context.
    self.definesPresentationContext = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadRecipes];
    selectedRow = 999999;
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
    cell.textLabel.text=recipe.recipeTitle;
    cell.imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:recipe.recipeUrl]]];
    cell.imageView.contentMode=UIViewContentModeScaleAspectFit;
    cell.imageView.frame = CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, 40,40);
    
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
    else if ([[segue identifier] isEqualToString:@"showAddRecipes"]) {
        if(selectedRow < 999999)
        {
            Recipe *choosenRecipe = [self.recipes objectAtIndex: selectedRow];
            AddRecipeViewController *addRecipeViewController=segue.destinationViewController;
            addRecipeViewController.currentRecipe=choosenRecipe;
        }
        else {
            AddRecipeViewController *addRecipeViewController=segue.destinationViewController;
            addRecipeViewController.currentRecipe=NULL;
            
        }
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedRow = indexPath.row;
    
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)  {
        Recipe *recipe = [self.recipes objectAtIndex: indexPath.row];
        NSLog(@"recipe: %@ %@", recipe.recipeId,recipe.ingredient);
        [[[self.ref child:@"Foodie/Recipes" ] child:recipe.recipeId] removeValue];
        [[[self.ref child:@"Foodie/Ingredient" ] child:recipe.ingredient] removeValue];
        [self.recipes removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }];
    delete.backgroundColor = [UIColor redColor];
    UITableViewRowAction *edit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [self performSegueWithIdentifier:@"showAddRecipes" sender:self];
    }];
    edit.backgroundColor = [UIColor blueColor];
    return @[delete, edit];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
