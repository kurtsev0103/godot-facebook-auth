//
//  FacebookProvider.h
//  GodotFacebookAuth
//
//  Created by Oleksandr Kurtsev on 12/09/2021.
//

#import <Foundation/Foundation.h>

@interface FacebookProvider : NSObject

+ (instancetype)shared;

- (void)signIn;
- (void)signOut;
- (void)credential;

@end
