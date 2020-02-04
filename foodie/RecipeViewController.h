//
//  RecipeViewController.h
//  foodie
//
//  Created by Aakash Bista on 7/1/20.
//  Copyright © 2020 Aakash Bista. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
#import "Ingredients.h"
@import Firebase;
NS_ASSUME_NONNULL_BEGIN

@interface RecipeViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate>
{
    @private
    NSInteger selectedRow;
}

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSMutableArray<Recipe *> *recipes;
@property (strong, nonatomic) NSMutableArray<Ingredients *> *ingredients;
@end

NS_ASSUME_NONNULL_END
