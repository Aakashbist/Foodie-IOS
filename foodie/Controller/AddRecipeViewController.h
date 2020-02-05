//
//  AddRecipeViewController.h
//  foodie
//
//  Created by Aakash Bista on 20/1/20.
//  Copyright © 2020 Aakash Bista. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface AddRecipeViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate , UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *ingredientTableView;

- (IBAction)saveRecipe:(id)sender;
- (IBAction)addIngredients:(id)sender;
- (IBAction)chooseRecipeImage:(id)sender;

@property (strong, nonatomic) NSString *ingredientTitle;
@property (strong, nonatomic) NSString *imageUrl;
@property (weak, nonatomic) Recipe *currentRecipe;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRStorage *storage;
@property (strong, nonatomic)  NSMutableArray *listOfIngredients;
@property (strong, nonatomic)  NSURL *path;
@property (weak, nonatomic)  NSString *recipeId;
@property (weak, nonatomic)  NSString *ingredientId;

@property (weak, nonatomic) IBOutlet UITextField *recipeTitle;
@property (strong, nonatomic) IBOutlet UITextField *ingredient;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImageView;
@property (weak, nonatomic) IBOutlet UIProgressView *uploadProgressView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveRecipeButton;
@property (weak, nonatomic) IBOutlet UIButton *addIngredientButton;



@end

NS_ASSUME_NONNULL_END
