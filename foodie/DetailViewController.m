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
@synthesize recipeId,recipeTitle,recipeImage,currentRecipe,addTofavouriteButton,ingredientId,addToShoppingList,ingredientTableView,listOfIngredients,ingredientTitle;

#pragma mark - Managing the detail item



- (void)viewDidLoad {
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];
    // Do any additional setup after loading the view, typically from a nib.
    ingredientTableView.delegate = self;
    ingredientTableView.dataSource = self;
    self.listOfIngredients=NSMutableArray.new;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    recipeId=currentRecipe.recipeId;
    ingredientId=currentRecipe.ingredient;
    recipeTitle.text=currentRecipe.recipeTitle;
    recipeImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:currentRecipe.recipeUrl]]];
    [self loadIngredients];
}

-(void)loadIngredients{
    FIRDatabaseQuery *getIngredients = [[[self.ref child:@"Foodie/Ingredient/"] queryOrderedByKey] queryEqualToValue:self.ingredientId];
    [getIngredients observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSArray* value  =[[snapshot.children nextObject] value];
        for (int i=0; i<value.count; i++) {
            self.ingredientTitle= [[value objectAtIndex:i] objectForKey:@"title"];
            NSLog(@"%@",self.ingredientTitle);
            [self.listOfIngredients addObject:self.ingredientTitle];
        }
        [self->ingredientTableView reloadData];
        
    }];
}

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ingredientCell" forIndexPath:indexPath];
    
    cell.textLabel.text=self.listOfIngredients[indexPath.row] ;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu",(unsigned long)self.listOfIngredients.count);
    return self.listOfIngredients.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
