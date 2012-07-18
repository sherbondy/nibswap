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
static NSString *kRemoteNibBaseURL = @"http://localhost/";

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor    = [UIColor whiteColor];
    _viewController                = [[ExampleViewController alloc] init];
    self.window.rootViewController = _viewController;
    [self.window makeKeyAndVisible];
    [self downloadBundle];
    return YES;
}

- (void)downloadBundle
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *bundleFilename = @"nibsample.bundle";
    NSString *bundlePath     = [documentsDirectory stringByAppendingPathComponent:bundleFilename];
    NSString *zipFilename    = [bundleFilename stringByAppendingString:@".zip"];
    NSURL *url               = [NSURL URLWithString:[kRemoteNibBaseURL stringByAppendingString:zipFilename]];
    NSURLRequest *request    = [NSURLRequest requestWithURL:url];
    
    NSHTTPURLResponse *response;
    NSError *error;
    
    // request the zipped bundle from the server
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"Status Code: %d", [response statusCode]);
    
    // check if the download went awry
    if ([response statusCode] == 404){
        [[NSFileManager defaultManager] removeItemAtPath:bundlePath error:nil];
        NSLog(@"Unable to grab the remote file.");
        return;
    } else if (error) {
        NSLog(@"Error: %@", error);
    }
    
    // save the downloaded file
    NSString *zipPath = [documentsDirectory stringByAppendingString:zipFilename];
    BOOL didWriteData = [data writeToFile:zipPath atomically:YES];
    if (didWriteData) {
        // unzip the bundle
        BOOL didUnzipBundle = [SSZipArchive unzipFileAtPath:zipPath toDestination:documentsDirectory];
        if (!didUnzipBundle) {
            NSLog(@"Failed to unzip file.");
        } else {
            NSLog(@"Success!");
        }
    }
    
    // initialize the bundle
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    if (!bundle) {
        NSLog(@"No bundle found.");
    }
    
    // hookup the IBOutlets
    NSDictionary *nibObjects = @{ @"nameLabel": _viewController.nameLabel};
    NSDictionary *proxies    = @{ UINibExternalObjects : nibObjects};
    
    // extract the nibs, in this case, a single UIView
    NSArray *nibs   = [bundle loadNibNamed:@"ExampleView" owner:_viewController options:proxies];
    UIView *nibView = [nibs objectAtIndex:0];

    // and now the big payoff
    _viewController.view = nibView;
    _viewController.nameLabel.text = @"Bob";    
}

@end
