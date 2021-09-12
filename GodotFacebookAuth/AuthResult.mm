//
//  AuthResult.m
//  GodotFacebookAuth
//
//  Created by Oleksandr Kurtsev on 12/09/2021.
//

#import "AuthResult.h"
#import "GodotFacebookAuth.h"
#import "core/engine.h"

void AuthResult::authorization(FBSDKAccessToken* token, id dict) {
    Dictionary result = Dictionary();
    result["token"] = String(token.tokenString.UTF8String);
    result["user_id"] = String(token.userID.UTF8String);
    result["email"] = "";
    result["name"] = "";
    
    if (dict != nil) {
        NSString *name = [dict valueForKey:@"name"];
        NSString *email = [dict valueForKey:@"email"];
        result["name"] = String(name.UTF8String);
        result["email"] = String(email.UTF8String);
    }
    
    Engine::get_singleton()->get_singleton_object(String(PLUGIN_NAME))->emit_signal(String(SIGNAL_AUTHORIZATION), result);
}

void AuthResult::credential(NSString* state) {
    Dictionary result = Dictionary();
    result["state"] = String(state.UTF8String);
    Engine::get_singleton()->get_singleton_object(String(PLUGIN_NAME))->emit_signal(String(SIGNAL_CREDENTIAL), result);
}

void AuthResult::auth_error(NSString* error) {
    Dictionary result = Dictionary();
    result["error"] = String(error.UTF8String);
    Engine::get_singleton()->get_singleton_object(String(PLUGIN_NAME))->emit_signal(String(SIGNAL_AUTHORIZATION), result);
}
