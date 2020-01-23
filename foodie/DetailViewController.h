//
//  DetailViewController.h
//  foodie
//
//  Created by Aakash Bista on 7/1/20.
//  Copyright © 2020 Aakash Bista. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController

@property (strong, nonatomic) FIRDatabaseReference *ref;

- (IBAction)addToFavourites:(id)sender;
- (IBAction)addToShoppingList:(id)sender;

@property (weak, nonatomic) IBOutlet NSString *recipeId;
@property (weak, nonatomic) IBOutlet NSString *ingredientId;
@property (weak, nonatomic) IBOutlet UILabel *recipeTitle;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (weak, nonatomic) IBOutlet NSMutableArray *listOfIngredients;
@property (strong, nonatomic) Recipe *currentRecipe;
@property (strong, nonatomic) IBOutlet UIButton *addTofavouriteButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addToShoppingList;


@end

NS_ASSUME_NONNULL_END
