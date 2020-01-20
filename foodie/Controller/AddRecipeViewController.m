//
//  AddRecipeViewController.m
//  foodie
//
//  Created by Aakash Bista on 20/1/20.
//  Copyright © 2020 Aakash Bista. All rights reserved.
//

#import "AddRecipeViewController.h"

@interface AddRecipeViewController ()

@end

@implementation AddRecipeViewController

@synthesize recipeTitle, ingredient,recipeImageView,listOfIngredients,path,storage,uploadProgressView;

- (void)viewDidLoad {
    [super viewDidLoad];
       self.ref = [[FIRDatabase database] reference];
        self.listOfIngredients=NSMutableArray.new;
        self.uploadProgressView.progress=0;
        self.uploadProgressView.hidden=true;
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
            NSLog(@"%f",percentComplete);
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
    [self saveRecipeImage];
}

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
    NSLog(@"URL: %@", path);
    self.recipeImageView.image=image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
