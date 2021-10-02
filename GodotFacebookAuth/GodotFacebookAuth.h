//
//  GodotFacebookAuth.h
//  GodotFacebookAuth
//
//  Created by Oleksandr Kurtsev on 12/09/2021.
//

#import "core/engine.h"

#define PLUGIN_NAME "GodotFacebookAuth"
#define PLUGIN_VERSION "1.0.1"

#define SIGNAL_CREDENTIAL "credential"
#define SIGNAL_AUTHORIZATION "authorization"

void init_godot_facebook_auth();
void deinit_godot_facebook_auth();

class GodotFacebookAuth : public Object {
    
    GDCLASS(GodotFacebookAuth, Object);
    static void _bind_methods();
    
public:
    
    void signIn();
    void signOut();
    void credential();
    
};
