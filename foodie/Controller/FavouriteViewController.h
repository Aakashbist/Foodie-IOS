//
//  FavouriteViewController.h
//  foodie
//
//  Created by Aakash Bista on 13/1/20.
//  Copyright © 2020 Aakash Bista. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
@import Firebase;
NS_ASSUME_NONNULL_BEGIN

@interface FavouriteViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) FIRDatabaseReference *ref;
 @property (strong, nonatomic) NSMutableArray<Recipe *> *recipes;
@end

NS_ASSUME_NONNULL_END
