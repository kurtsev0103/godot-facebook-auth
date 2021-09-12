//
//  AuthResult.h
//  GodotFacebookAuth
//
//  Created by Oleksandr Kurtsev on 12/09/2021.
//

#import <Foundation/Foundation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "core/engine.h"

class AuthResult {
    
public:
    
    static void credential(NSString* state);
    static void auth_error(NSString* error);
    static void authorization(FBSDKAccessToken* token, id dict);
    
};
