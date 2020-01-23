//
//  Recipe.h
//  foodie
//
//  Created by Aakash Bista on 9/1/20.
//  Copyright © 2020 Aakash Bista. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ingredients.h"

NS_ASSUME_NONNULL_BEGIN

@interface Recipe : NSObject

@property (strong, nonatomic) NSString *recipeId;
@property (strong, nonatomic) NSString *recipeTitle;
@property (strong, nonatomic) NSString *recipeUrl;
@property (strong, nonatomic) NSString *ingredient;


@end

NS_ASSUME_NONNULL_END
