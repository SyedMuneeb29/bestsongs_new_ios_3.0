//
//  LoginViewController.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 10/15/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"

@interface LoginViewController ()
{
    NSDictionary *regionDataRecv;
    
    NSNumber *regionCode;
    NSNumber *errorCode;
}
@end

@implementation LoginViewController

@synthesize skipButtonView , sharingStackView;


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}




- (void) contentNotAvailablePopUp{
    
    errorCode =  [NSNumber numberWithInteger:403];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@"http://bestsongs-156307.appspot.com/v1/check_region"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSInteger statusCode = httpResponse.statusCode;
        
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (statusCode == (NSInteger)403){

                
                self.addToContentNotAvailablePopupViewController = [[ContentNotAvailableViewController alloc] init];
                [self presentViewController:_addToContentNotAvailablePopupViewController animated:YES completion:nil];
                
                
            }
        });
        
      
    
    }];
    
    [dataTask resume];
    
  
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self contentNotAvailablePopUp];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self contentNotAvailablePopUp];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"videoViewIsDisplayed" object:nil];
    
    
    _IsVideo = NO;
    _IsAlbum = NO;
    
    self.skipButtonView.layer.cornerRadius = 30;
    self.skipButtonView.layer.masksToBounds = YES;
    
    self.facebookSigninButton.layer.cornerRadius = 22;
    self.facebookSigninButton.layer.masksToBounds = YES;
    
    self.googleSigninButton.layer.cornerRadius = 22;
    self.googleSigninButton.layer.masksToBounds = YES;
    
    self.bestsongSigninButton.layer.cornerRadius = 22;
    self.bestsongSigninButton.layer.masksToBounds = YES;
    
    self.storage = [FIRStorage storage];
    self.storageRef = [self.storage referenceForURL:@"gs://bestsongs-a5062.appspot.com"];
    
    
    
    
  [[ NSNotificationCenter defaultCenter ] postNotificationName:@"hideHomeAdd" object:nil];
    
}

- (void) openDynamicLink{
    if(_IsVideo){
        [[BaseController sharedInstance] openVideoPlayer:self.storyboard andVideo:self.video andRootViewController:self.rootViewController];
    } else if(_IsAlbum){
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)closeButton:(id)sender {
    
    [self dismiss];
}

- (IBAction)facebookSigninButtonTouch:(id)sender {
    
    if ([self facebookIsSetup]) {
        [self ShowLoading];
        [self facebookLogin];
    }
}

- (BOOL)facebookIsSetup {
    NSString *facebookAppId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"FacebookAppID"];
    BOOL canOpenFacebook =[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"fb%@://", facebookAppId]]];
    if (!canOpenFacebook) {
        //NSLog(@"Please set FacebookAppID, FacebookDisplayName, and\nURL types > Url Schemes in `Supporting Files/Info.plist`");
        return NO;
    } else {
        return YES;
    }
}

- (void)facebookLogin {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    
    
    [login logInWithPermissions:@[@"public_profile", @"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            [self HideLoading];
        } else if ([FBSDKAccessToken currentAccessToken]) {
            NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
            [parameters setValue:@"id,name,email,gender,picture.width(100).height(100)" forKey:@"fields"];
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     NSDictionary *dictionary = result;
                     NSString *name = @"";
                     NSString *email = @"";
                     NSString *gender = @"";
                     if([result objectForKey:@"name"])
                         name = [result objectForKey:@"name"] == NULL ? @"" : [NSString stringWithFormat:@"%@", [result objectForKey:@"name"]];
                     if([result objectForKey:@"email"])
                         email = [result objectForKey:@"email"] == NULL ? @"" : [NSString stringWithFormat:@"%@", [result objectForKey:@"email"]];
                     if([result objectForKey:@"gender"])
                         gender = [result objectForKey:@"gender"] == NULL ? @"" : [NSString stringWithFormat:@"%@", [result objectForKey:@"gender"]];
                     
                     NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"]]];
                     
                     FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                                      credentialWithAccessToken:[FBSDKAccessToken currentAccessToken].tokenString];
                     [self registerWithDetails:credential andName:name andEmail:email andGender:gender andImageURL:imageURL];
                     
                 } else {
                     [self HideLoading];
                 }
             }];
        } else if (result.isCancelled) {
            [self HideLoading];
        }
    }];
}

- (IBAction)googleSigninButtonTouch:(id)sender {
    if ([self googleIsSetup]) {
        [self ShowLoading];
        [self googleLogin];
    }
}

- (BOOL)googleIsSetup {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GoogleService-Info" ofType:@"plist"];
    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *reversedClientId =[plist objectForKey:@"REVERSED_CLIENT_ID"];
    BOOL clientIdExists = [plist objectForKey:@"CLIENT_ID"] != nil;
    BOOL reversedClientIdExists = reversedClientId != nil;
    BOOL canOpenGoogle =[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://", reversedClientId]]];
    if (!(clientIdExists && reversedClientIdExists && canOpenGoogle)) {
        //NSLog(@"Please add `GoogleService-Info.plist` to `Supporting Files` and\nURL types > Url Schemes in `Supporting Files/Info.plist`");
        return NO;
    } else {
        return YES;
    }
}

- (void)googleLogin {
    GIDSignIn *googleSignIn = [GIDSignIn sharedInstance];
    googleSignIn.shouldFetchBasicProfile = YES;
    googleSignIn.delegate = self;
    googleSignIn.uiDelegate = self;
    [googleSignIn signIn];
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    
    
    if (error == nil) {
        GIDAuthentication *authentication = user.authentication;
        FIRAuthCredential *credential =
        [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken
                                         accessToken:authentication.accessToken];
        [self registerWithDetails:credential andName:user.profile.name andEmail:user.profile.email andGender:@"" andImageURL:[user.profile imageURLWithDimension:10]];
    } else {
        [self HideLoading];
    }
    
    
}

- (void)registerWithDetails:(FIRAuthCredential *)credential andName:(NSString *)name andEmail:(NSString *)email andGender:(NSString *)gender andImageURL:(NSURL *)imageURL{
    
     [self contentNotAvailablePopUp];
    
    [[FIRAuth auth] signInWithCredential:credential
                              completion:^(FIRUser *user, NSError *error) {
                                  if(error != nil){
                                      [self HideLoading];
                                      return;
                                  }
                                  NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:imageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                      if (data) {
                                          FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
                                          metadata.contentType = @"image/jpeg";
                                          FIRStorageReference *imageRef = [[[self.storageRef child:@"users"] child:@"images"] child:[NSString stringWithFormat:@"profile/%@_profile.jpg",user.uid]];
                                          
                                          
                                          //muneeb sort nil
                                          
                                          FIRStorageUploadTask *uploadTask = [imageRef putData:data
                                                                                      metadata:metadata
                                                                                    completion:^(FIRStorageMetadata *metadata,
                                                                                                 NSError *error) {
                                                                                        if (error != nil) {
                                                                                            [self HideLoading];
                                                                                            [[BaseController sharedInstance] showToastError:error.localizedDescription];
                                                                                        } else {
                                                                                            self.user = [[User alloc] initWithID:user.uid andName:name andEmail:email andGender:gender
                                                                                                                     andPhotoURL:nil];
                                                                                            [[BaseController sharedInstance] registerNewUser:_user andFirebaseUser:user callback:^(NSError *error, BOOL success) {
                                                                                                if(success){
                                                                                                    [self HideLoading];
                                                                                                    
                                                                                                    
                                                                                                    [[BestsongsAPI sharedInstance] fetchPlaylists:^(id response) {
                                                                                                        
                                                                                                        NSDictionary *dataDictionary = (NSDictionary *) response;
                                                                                                        NSMutableArray *playlistArray = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getPlaylistsArrayFromJSON:[dataDictionary objectForKey:@"playlists"]]];
                                                                                                        
                                                                                                        NSUInteger arrayLength = [playlistArray count];
                                                                                                        
                                                                                                        
                                                                                                        if (arrayLength > 0)
                                                                                                        {
                                                                                                            [[BaseController sharedInstance] showToastSuccess:@"Playlist Successfully Imported"];
                                                                                                        }
                                                                                                        //                        else
                                                                                                        //                        {
                                                                                                        //
                                                                                                        //                        }
                                                                                                        
                                                                                                    }
                                                                                                                                        onFailure:^(NSError *error) {
                                                                                                                                        }];
                                                                                                    
                                                                                                    
                                                                                                    [self dismiss];
                                                                                                    
                                                                                                } else {
                                                                                                    [self HideLoading];
                                                                                                    [[BaseController sharedInstance] showToastError:@"Error Occured While Importing Playlists"];
                                                                                                    [self dismiss];
                                                                                                }
                                                                                            }];
                                                                                        }
                                                                                    }];
                                          [uploadTask resume];
                                      } else {
                                          [self HideLoading];
                                      }
                                  }];
                                  [task resume];
                              }];
}

- (IBAction)bestsongSigninButtonTouch:(id)sender {
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    LoginPopupViewController *loginPopupViewController = [LoginPopupViewController instantiateFromNib];
    [loginPopupViewController loadData];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        [loginPopupViewController setFrame:CGRectMake(0, 0, 400, 400)];
    else
        [loginPopupViewController setFrame:CGRectMake(0, 0, (screenRect.size.width - 50), 400)];
    loginPopupViewController.didDismiss = ^(NSString *data) {
        if([[BaseController sharedInstance] checkIsUserLogin]){
            [self dismiss];
        }
    };
    CNPPopupController *newPopupController = [[CNPPopupController alloc] initWithContents:@[loginPopupViewController]];
    newPopupController.theme = [[BaseController sharedInstance] cnPopupDefaultTheme];
    newPopupController.theme.presentationStyle = CNPPopupPresentationStyleFadeIn;
    newPopupController.delegate = self;
    loginPopupViewController.popupController = newPopupController;
    [newPopupController presentPopupControllerAnimated:YES];
    
    
}



- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (void)ShowLoading {
    [[BaseController sharedInstance] setupLoading];
    [SVProgressHUD show];
}

- (void)HideLoading {
    [SVProgressHUD dismiss];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
    [super viewDidAppear:animated];
    
    
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"videoViewIsDisappearing" object:nil];
    
    [self resignFirstResponder];
    [super viewDidDisappear:animated];
    [self openDynamicLink];
}

- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
//    if (self.didDismiss)
//        self.didDismiss(@"some extra data");
}

@end
