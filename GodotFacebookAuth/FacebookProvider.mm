//
//  FacebookProvider.m
//  GodotFacebookAuth
//
//  Created by Oleksandr Kurtsev on 12/09/2021.
//

#import "FacebookProvider.h"
#import "AuthResult.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@implementation FacebookProvider

+ (instancetype)shared {
    static FacebookProvider *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [FacebookProvider new];
    });
    return shared;
}

- (void)signIn {
    NSArray* permissions = @[@"public_profile", @"email"];
    FBSDKLoginManager *manager = [FBSDKLoginManager new];
    
    NSPredicate *isKeyWindow = [NSPredicate predicateWithFormat:@"isKeyWindow == YES"];
    UIWindow *keyWindow = [[[UIApplication sharedApplication] windows] filteredArrayUsingPredicate:isKeyWindow].firstObject;
    UIViewController *vc = keyWindow.rootViewController;
    
    [manager logInWithPermissions:permissions fromViewController:vc handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
        
        if ([result isCancelled]) {
            AuthResult::auth_error(@"The login was cancelled by the user.");
            return;
        } else if (error != nil) {
            AuthResult::auth_error(error.localizedDescription);
            return;
        }
        
        FBSDKAccessToken *token = result.token;
        NSDictionary *params = @{@"fields": @"name,email"};
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:params];
        [request startWithCompletion:^(id<FBSDKGraphRequestConnecting>  _Nullable connection, id  _Nullable result, NSError * _Nullable error) {
            if (error != nil) {
                AuthResult::authorization(token, nil);
                return;
            }
            
            AuthResult::authorization(token, result);
        }];
    }];
}

- (void)signOut {
    FBSDKLoginManager *manager = [FBSDKLoginManager new];
    [manager logOut];
}

- (void)credential {
    if ([FBSDKAccessToken currentAccessToken] && [FBSDKAccessToken isCurrentAccessTokenActive]) {
        AuthResult::credential(@"authorized");
    } else if ([FBSDKAccessToken currentAccessToken] && ![FBSDKAccessToken isCurrentAccessTokenActive]) {
        AuthResult::credential(@"revoked");
    } else {
        AuthResult::credential(@"not_found");
    }
}

@end
