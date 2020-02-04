
#import "AddRecipeViewController.h"

@interface AddRecipeViewController ()

@end

@implementation AddRecipeViewController

@synthesize recipeTitle, ingredient,recipeImageView,listOfIngredients,path,storage,uploadProgressView,addIngredientButton,saveRecipeButton,currentRecipe,recipeId,ingredientId,ingredientTableView,ingredientTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];
    listOfIngredients = [[NSMutableArray alloc] init];
    uploadProgressView.progress=0;
    uploadProgressView.hidden=true;
    ingredientTableView.delegate = self;
    ingredientTableView.dataSource = self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(currentRecipe != NULL){
        recipeId=currentRecipe.recipeId;
        path=currentRecipe.recipeUrl;
        ingredientId=currentRecipe.ingredient;
        recipeTitle.text=currentRecipe.recipeTitle;
        recipeImageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:currentRecipe.recipeUrl]]];
        [self loadIngredients];
        
    }
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


- (void) saveRecipeImage{
    if (self.recipeImageView.image != nil)
    {
        FIRStorage *storage = [FIRStorage storage];
        FIRStorageReference *recipeRef=[storage reference];
        
        NSString *imageID = [[NSUUID UUID] UUIDString];
        NSString *imageName = [NSString stringWithFormat:@"recipe image/%@.jpg",imageID];
        FIRStorageReference *recipeImageRef = [recipeRef child:imageName];
        FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
        metadata.contentType = @"image/jpeg";
        NSData *imageData = UIImageJPEGRepresentation(self.recipeImageView.image, 0.8);
        // Upload file and metadata to the object 'images/mountains.jpg'
        FIRStorageUploadTask *uploadTask = [recipeImageRef putData:imageData metadata:metadata];
        [uploadTask observeStatus:FIRStorageTaskStatusProgress handler:^(FIRStorageTaskSnapshot *snapshot) {
            // Upload reported progress
            double percentComplete = 100.0 * (snapshot.progress.completedUnitCount) / (snapshot.progress.totalUnitCount);
            self.uploadProgressView.hidden=false;
            self.uploadProgressView.progress=(percentComplete/100);
        }];
        
        [uploadTask observeStatus:FIRStorageTaskStatusSuccess handler:^(FIRStorageTaskSnapshot *snapshot) {
            if (!snapshot.error ) {
                [recipeImageRef downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                    if (error != nil) {
                        NSLog(@" %@",error.localizedDescription);
                    } else {
                        NSString *downloadURL = URL.absoluteString;
                        NSLog(@" %@",downloadURL);
                        [self addRecipeToFirebase:downloadURL];
                    }
                }];
            }
            else if (snapshot.error)
            {
                NSLog(@"Failed to upload recipe image, %@",snapshot.error.localizedDescription);
            }
        }];
    }
    
    else{
        NSLog(@"Failed");
    }
    
    
}
- (IBAction)saveRecipe:(id)sender {
    if(recipeId){
        [self updateRecipe];
    }
    else{
        [self saveRecipeImage];
        
    }
    self.addIngredientButton.enabled=false;
    self.saveRecipeButton.enabled=false;
}

-(void)updateRecipe{
 NSDictionary *post = @{
       @"title": [recipeTitle text],
       @"url": path,
       @"ingredient":ingredientId
   };
    NSDictionary *childUpdates = @{[@"/Foodie/Recipes/" stringByAppendingString:recipeId]: post};
       [_ref updateChildValues:childUpdates];}

-(void)addRecipeToFirebase:(NSString *) imageUrl{
    NSString *ingredientKey=[self addIngredientToFirebase:listOfIngredients];
    NSString *key = [[_ref child:@"Foodie/Recipes"] childByAutoId].key;
    NSDictionary *post = @{
        @"title": [recipeTitle text],
        @"url": imageUrl,
        @"ingredient":ingredientKey
    };
    NSDictionary *childUpdates = @{[@"/Foodie/Recipes/" stringByAppendingString:key]: post};
    [_ref updateChildValues:childUpdates];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString*)addIngredientToFirebase:(NSArray*) ingredientList{
    
    NSMutableArray *data=NSMutableArray.new;
    NSString *key = [[_ref child:@"Foodie/Ingredient"] childByAutoId].key;
    for (int i=0; i<[ingredientList count]; i++) {
        NSDictionary *post = @{
            @"title":[listOfIngredients objectAtIndex:i]
        };
        [ data addObject:post ];
    }
    NSDictionary *childUpdates = @{[@"/Foodie/Ingredient/" stringByAppendingString:key]: data};
    [_ref updateChildValues:childUpdates];
    return key;
}

-(IBAction)addIngredients:(id)sender {
    [self.listOfIngredients addObject:[ingredient text]];
    [ingredientTableView reloadData];
    ingredient.text=@"";
}



#pragma mark - getImagefromPhone

-(IBAction)chooseRecipeImage:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    UIImage *image= [info valueForKey:UIImagePickerControllerOriginalImage];
    NSURL *url=[info valueForKey:UIImagePickerControllerImageURL];
    self.path=url;
    self.recipeImageView.image=image;
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(self.listOfIngredients.count){
    return @"Ingredient";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ingredientCell" forIndexPath:indexPath];
    
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@",listOfIngredients[indexPath.row]]];

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
