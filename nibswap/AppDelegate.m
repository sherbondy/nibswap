//
//  AppDelegate.m
//  nibswap
//
//  Created by Ethan Sherbondy on 7/9/12.
//  Copyright (c) 2012 MIT. All rights reserved.
//

#import <SSZipArchive.h>

#import "AppDelegate.h"
#import "ExampleViewController.h"

// replace this with the base url where you stored example.nib.zip
static NSString *kRemoteNibBaseURL = @"http://localhost/~ethanis/";

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];    
    return [self downloadBundle];
}

- (BOOL)downloadBundle
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *bundleFilename = @"example.bundle";
    NSString *zipFilename = [bundleFilename stringByAppendingString:@".zip"];
    NSURL *url = [NSURL URLWithString:[kRemoteNibBaseURL stringByAppendingString:zipFilename]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSLog(@"%d", [httpResponse statusCode]);
        
    if ([httpResponse statusCode] == 404){
        NSString *path = [documentsDirectory stringByAppendingPathComponent:bundleFilename];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        NSLog(@"Unable to grab the remote file.");
        return NO;
    }
    else if (error) {
        NSLog(@"Error: %@", error);
    }
    
    NSString *zipFile = [documentsDirectory stringByAppendingString:zipFilename];
    BOOL didWriteData = [data writeToFile:zipFile atomically:YES];
    if (didWriteData) {
        BOOL success = [SSZipArchive unzipFileAtPath:zipFile toDestination:documentsDirectory];
        if (!success) {
            NSLog(@"failed to unzip file.");
        } else {
            NSLog(@"Success!");
        }
    }
    
    NSString *file = [documentsDirectory stringByAppendingPathComponent:bundleFilename];
    NSBundle *bundle = [NSBundle bundleWithPath:file];
    if (!bundle) {
        NSLog(@"no bundle found.");
    }
        
    ExampleViewController *viewController = [[ExampleViewController alloc] init];
    
    NSDictionary *nibObjects = @{ @"nameLabel": viewController.nameLabel};
    NSDictionary *proxies    = @{ UINibExternalObjects : nibObjects};
    
    NSArray *nibs = [bundle loadNibNamed:@"ExampleView" owner:viewController options:proxies];
    // use options to hook up iboutlets
    UIView *nibView = [nibs objectAtIndex:0];

    self.window.rootViewController = viewController;
    viewController.view = nibView;
    viewController.nameLabel.text = @"Bob";
    
    return YES;
}

@end
