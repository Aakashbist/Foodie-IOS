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
@synthesize recipeId,recipeTitle,recipeImage,listOfIngredients,currentRecipe,addTofavouriteButton,ingredientId,addToShoppingList;

#pragma mark - Managing the detail item

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    recipeId=currentRecipe.recipeId;
    ingredientId=currentRecipe.ingredient;
   recipeTitle.text=currentRecipe.recipeTitle;
   recipeImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:currentRecipe.recipeUrl]]];
    [self loadIngredients];
}

-(void)loadIngredients{
  
    listOfIngredients=NSMutableArray.new;
    Ingredients *ingredient=Ingredients.new;
    FIRDatabaseQuery *getRecipesQuery = [[[self.ref child:@"Foodie/Ingredient/"] queryOrderedByKey] queryEqualToValue:ingredientId];
    [getRecipesQuery observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSArray* value  =[[snapshot.children nextObject] value];
            for (int i=0; i<value.count; i++) {
                [ingredient  setTitle:[[value objectAtIndex:i] objectForKey:@"title"]];
                [self.listOfIngredients addObject:ingredient];
            }
        }];
    NSLog(@"%lu",(unsigned long)self.listOfIngredients.count);

}

- (void)viewDidLoad {
    [super viewDidLoad];
         self.ref = [[FIRDatabase database] reference];
    // Do any additional setup after loading the view, typically from a nib.
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addToFavourites:(id)sender {
    NSString *key = [[_ref child:@"Foodie/Favourites"] childByAutoId].key;
           NSDictionary *post = @{
               @"favourite": recipeId,
           };
           NSDictionary *childUpdates = @{[@"/Foodie/Favourites/" stringByAppendingString:key]: post};
              [_ref updateChildValues:childUpdates];
    self.addTofavouriteButton.enabled=false;
        
}

- (IBAction)addToShoppingList:(id)sender {
    NSString *key = [[_ref child:@"Foodie/Shopping"] childByAutoId].key;
    NSDictionary *post = @{
        @"ingredients": ingredientId,
        @"recipeTitle":currentRecipe.recipeTitle,
    };
    NSDictionary *childUpdates = @{[@"/Foodie/Shopping/" stringByAppendingString:key]: post};
    [_ref updateChildValues:childUpdates];
    self.addToShoppingList.enabled=false;

}
@end
