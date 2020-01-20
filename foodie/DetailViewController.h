//
//  DetailViewController.h
//  foodie
//
//  Created by Aakash Bista on 7/1/20.
//  Copyright © 2020 Aakash Bista. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController
- (IBAction)addToFavourites:(id)sender;
- (IBAction)addToShoppingList:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *recipeTitle;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (weak, nonatomic) IBOutlet NSMutableArray *ingredients;
@property (strong, nonatomic) Recipe *currentRecipe;
@end

NS_ASSUME_NONNULL_END
