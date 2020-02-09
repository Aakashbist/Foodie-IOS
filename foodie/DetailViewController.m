//
//  DetailViewController.m
//  foodie
//
//  Created by Aakash Bista on 7/1/20.
//  Copyright © 2020 Aakash Bista. All rights reserved.
//

#import "DetailViewController.h"
#import "Ingredients.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize recipeId,recipeTitle,recipeImage,currentRecipe,addTofavouriteButton,ingredientId,addToShoppingList,ingredientTableView,listofRecipeIngredients,ingredientTitle;

#pragma mark - Managing the detail item



- (void)viewDidLoad {
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];
    // Do any additional setup after loading the view, typically from a nib.
    ingredientTableView.delegate = self;
    ingredientTableView.dataSource = self;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    recipeId=currentRecipe.recipeId;
    ingredientId=currentRecipe.ingredient;
    recipeTitle.text=currentRecipe.recipeTitle;
    recipeImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:currentRecipe.recipeUrl]]];
    self.listofRecipeIngredients=NSMutableArray.new;
    [self loadIngredients];
}

-(void)loadIngredients{
    FIRDatabaseQuery *getIngredients = [[[self.ref child:@"Foodie/Ingredient/"] queryOrderedByKey] queryEqualToValue:self.ingredientId];
    [getIngredients observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSArray* value  =[[snapshot.children nextObject] value];
        for (int i=0; i<value.count; i++) {
            self.ingredientTitle= [[value objectAtIndex:i] objectForKey:@"title"];
            [self.listofRecipeIngredients addObject:self.ingredientTitle];
        }
        [self->ingredientTableView reloadData];
        
    }];
}

- (IBAction)addToFavourites:(id)sender {
    NSDictionary *post = @{
        @"favourite": recipeId,
    };
    NSDictionary *childUpdates = @{[@"/Foodie/Favourites/" stringByAppendingString:recipeId]: post};
    [_ref updateChildValues:childUpdates];
    self.addTofavouriteButton.enabled=false;
    
}

- (IBAction)addToShoppingList:(id)sender {
    NSDictionary *post = @{
        @"ingredients": ingredientId,
        @"recipeTitle":currentRecipe.recipeTitle,
    };
    NSDictionary *childUpdates = @{[@"/Foodie/Shopping/" stringByAppendingString:ingredientId]: post};
    [_ref updateChildValues:childUpdates];
    self.addToShoppingList.enabled=false;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ingredientCell" forIndexPath:indexPath];
    cell.textLabel.text=self.listofRecipeIngredients[indexPath.row] ;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listofRecipeIngredients.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
