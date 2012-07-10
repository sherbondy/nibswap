//
//  AppDelegate.m
//  nibswap
//
//  Created by Ethan Sherbondy on 7/9/12.
//  Copyright (c) 2012 MIT. All rights reserved.
//

#import "AppDelegate.h"
#import <SSZipArchive.h>

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
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSLog(@"%d", [httpResponse statusCode]);
        
    if ([httpResponse statusCode] == 404) // bundle will be deleted and the default interface will be used ...
    {
        NSString *path = [documentsDirectory stringByAppendingPathComponent:bundleFilename];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        return NO;
    }
    else if (error)
    {
        NSLog(@"%@", error);
    }
    
    NSString *zipFile = [documentsDirectory stringByAppendingString:zipFilename];
    BOOL didWriteData = [data writeToFile:zipFile atomically:YES];
    if (didWriteData)
    {
        BOOL success = [SSZipArchive unzipFileAtPath:zipFile toDestination:documentsDirectory];
        if (!success)
        {
            NSLog(@"failed to unzip file.");
        } else {
            NSLog(@"Success!");
        }
    }
    
    NSString *file = [documentsDirectory stringByAppendingPathComponent:bundleFilename];
    NSBundle *bundle = [NSBundle bundleWithPath:file];
    if (!bundle)
    {
        NSLog(@"no bundle found.");
    }
    
    UIViewController *viewController = [[UIViewController alloc] init];
    NSArray *nibs = [bundle loadNibNamed:@"ExampleView" owner:viewController options:nil];
    // use options to hook up iboutlets
    UIView *nibView = [nibs objectAtIndex:0];

    self.window.rootViewController = viewController;
    viewController.view = nibView;
    
    return YES;
}

@end
