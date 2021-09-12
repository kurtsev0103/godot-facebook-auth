//
//  GodotFacebookAuth.m
//  GodotFacebookAuth
//
//  Created by Oleksandr Kurtsev on 12/09/2021.
//

#import "GodotFacebookAuth.h"
#import "FacebookProvider.h"
#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#pragma mark - Initialization -

GodotFacebookAuth *plugin;

void init_godot_facebook_auth() {
    plugin = memnew(GodotFacebookAuth);
    Engine::get_singleton()->add_singleton(Engine::Singleton(PLUGIN_NAME, plugin));
    [FBSDKApplicationDelegate.sharedInstance initializeSDK];
}

void deinit_godot_facebook_auth() {
    if (plugin) {
       memdelete(plugin);
   }
}

void GodotFacebookAuth::_bind_methods() {
    ClassDB::bind_method(D_METHOD("sign_in"), &GodotFacebookAuth::signIn);
    ClassDB::bind_method(D_METHOD("sign_out"), &GodotFacebookAuth::signOut);
    ClassDB::bind_method(D_METHOD("credential"), &GodotFacebookAuth::credential);
    
    ADD_SIGNAL(MethodInfo(String(SIGNAL_CREDENTIAL), PropertyInfo(Variant::DICTIONARY, "result")));
    ADD_SIGNAL(MethodInfo(String(SIGNAL_AUTHORIZATION), PropertyInfo(Variant::DICTIONARY, "result")));
}

#pragma mark - Implementation -

void GodotFacebookAuth::signIn() {
    [FacebookProvider.shared signIn];
}

void GodotFacebookAuth::signOut() {
    [FacebookProvider.shared signOut];
}

void GodotFacebookAuth::credential() {
    [FacebookProvider.shared credential];
}
