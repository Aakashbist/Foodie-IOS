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

@end

@implementation RecipeViewController

@synthesize recipes,ingredients;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadRecipes];
    selectedRow = 999999;
}

-(void)viewDidDisappear:(BOOL)animated{
   [self.ref removeObserverWithHandle:handler];
     
}

-(void)loadRecipes{
    FIRDatabaseQuery *getRecipesQuery = [[self.ref child:@"Foodie/Recipes"] queryOrderedByKey];
    self.recipes=NSMutableArray.new;
    handler=  [getRecipesQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if([snapshot exists]){
            Recipe *recipe=Recipe.new;
                 [recipe setRecipeId:snapshot.key];
                 [recipe setRecipeTitle:[snapshot.value objectForKey:@"title"]];
                 [recipe setRecipeUrl:[snapshot.value objectForKey:@"url"]];
                 [recipe setIngredient:[snapshot.value objectForKey:@"ingredient"]];
                 @synchronized (self) {
                     if(![self.recipes containsObject:recipe]){
                         [self.recipes  addObject:recipe];
                     }
                 }
                 [self.tableView reloadData];
        }
     
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        [getRecipesQuery removeAllObservers];
    }] ;
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
    if(sender){
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
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedRow = indexPath.row;
    
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)  {
        Recipe *recipe = [self.recipes objectAtIndex: indexPath.row];
        
        [[[self.ref child:@"Foodie/Ingredient" ] child:recipe.ingredient] removeValue];
        [[[self.ref child:@"Foodie/Favourites" ] child:recipe.recipeId] removeValue] ;
        [[[self.ref child:@"Foodie/Shopping" ] child:recipe.ingredient] removeValue];
        [[[self.ref child:@"Foodie/Recipes" ] child:recipe.recipeId] removeValue];
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
