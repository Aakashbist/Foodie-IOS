//
//  ShoppingViewController.h
//  foodie
//
//  Created by Aakash Bista on 13/1/20.
//  Copyright © 2020 Aakash Bista. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ingredients.h"
@import Firebase;
NS_ASSUME_NONNULL_BEGIN

@interface ShoppingViewController : UITableViewController
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSMutableArray *listOfIngredients;
@property (strong, nonatomic) NSString *ingredientTitle;
@end
NS_ASSUME_NONNULL_END
