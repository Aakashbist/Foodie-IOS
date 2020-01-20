//
//  Recipe.m
//  foodie
//
//  Created by Aakash Bista on 9/1/20.
//  Copyright © 2020 Aakash Bista. All rights reserved.
//

#import "Recipe.h"


@implementation Recipe

@synthesize recipeTitle;
@synthesize recipeUrl;


-(void)initWithRecipeTitle:(NSString *) recipeTitle recipeUrl:(NSString *) recipeUrl{
    [self setRecipeTitle:recipeTitle];
    [self setRecipeUrl:recipeUrl];
}
@end
