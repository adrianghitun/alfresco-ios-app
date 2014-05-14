//
//  UniversalDevice.m
//  AlfrescoApp
//
//  Created by Tauseef Mughal on 29/07/2013
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "UniversalDevice.h"
#import "RootRevealControllerViewController.h"
#import "DetailSplitViewController.h"
#import "NavigationViewController.h"
#import "ItemInDetailViewProtocol.h"
#import "PlaceholderViewController.h"
#import "ContainerViewController.h"
#import "SwitchViewController.h"
#import "FolderPreviewViewController.h"
#import "DocumentPreviewViewController.h"

static FolderPreviewViewController *folderPreviewController;
static DocumentPreviewViewController *documentPreviewController;

@implementation UniversalDevice

+ (void)pushToDisplayFolderPreviewControllerForAlfrescoDocument:(AlfrescoFolder *)folder
                                                    permissions:(AlfrescoPermissions *)permissions
                                                        session:(id<AlfrescoSession>)session
                                           navigationController:(UINavigationController *)navigationController
                                                       animated:(BOOL)animated
{
    if (folderPreviewController != nil && [self controllerDisplayedInDetailNavigationController] == folderPreviewController)
    {
        [folderPreviewController updateToAlfrescoNode:folder permissions:permissions session:session];
    }
    else
    {
        if (folderPreviewController == nil)
        {
            folderPreviewController = [[FolderPreviewViewController alloc] initWithAlfrescoFolder:folder permissions:permissions session:session];
        }
        else
        {
            [folderPreviewController updateToAlfrescoNode:folder permissions:permissions session:session];
        }
        
        [self pushToDisplayViewController:folderPreviewController usingNavigationController:navigationController animated:animated];
    }
}

+ (void)pushToDisplayDocumentPreviewControllerForAlfrescoDocument:(AlfrescoDocument *)document
                                                      permissions:(AlfrescoPermissions *)permissions
                                                          session:(id<AlfrescoSession>)session
                                             navigationController:(UINavigationController *)navigationController
                                                         animated:(BOOL)animated
{
    // TODO
}

+ (void)pushToDisplayViewController:(UIViewController *)viewController usingNavigationController:(UINavigationController *)navigationController animated:(BOOL)animated;
{
    if (IS_IPAD)
    {
        UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        
        if ([rootViewController isKindOfClass:[ContainerViewController class]])
        {
            ContainerViewController *containerViewController = (ContainerViewController *)rootViewController;
            RootRevealControllerViewController *splitViewController = (RootRevealControllerViewController *)containerViewController.rootViewController;
            UIViewController *rootDetailController = splitViewController.detailViewController;
            if ([rootDetailController isKindOfClass:[DetailSplitViewController class]])
            {
                DetailSplitViewController *rootDetailSplitViewController = (DetailSplitViewController *)rootDetailController;
                UIViewController *controllerInRootDetailSplitViewController = rootDetailSplitViewController.detailViewController;
                
                if ([controllerInRootDetailSplitViewController isKindOfClass:[NavigationViewController class]])
                {
                    NavigationViewController *detailNavigationViewController = (NavigationViewController *)controllerInRootDetailSplitViewController;
                    
                    if ([viewController isKindOfClass:[NavigationViewController class]])
                    {
                        viewController = [(NavigationViewController *)viewController rootViewController];
                    }
                    
                    [detailNavigationViewController resetRootViewControllerWithViewController:viewController];
                }
            }
        }
        else
        {
            [navigationController pushViewController:viewController animated:animated];
        }
    }
    else
    {
        [navigationController pushViewController:viewController animated:animated];
    }
}

+ (void)displayModalViewController:(UIViewController *)viewController onController:(UIViewController *)controller withCompletionBlock:(void (^)(void))completionBlock
{
    if (IS_IPAD)
    {
        viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [controller presentViewController:viewController animated:YES completion:^{
        if (completionBlock != NULL)
        {
            completionBlock();
        }
    }];
}

+ (void)clearDetailViewController
{
    if (IS_IPAD)
    {
        PlaceholderViewController *viewController = [[PlaceholderViewController alloc] init];
        [UniversalDevice pushToDisplayViewController:viewController usingNavigationController:nil animated:NO];
    }
    else
    {
        RootRevealControllerViewController *rootRevealViewController = (RootRevealControllerViewController *)[self revealViewController];
        SwitchViewController *switchViewController = (SwitchViewController *)[rootRevealViewController detailViewController];
        UINavigationController *navController = (UINavigationController *)[switchViewController displayedViewController];
        [navController popViewControllerAnimated:NO];
    }
}

+ (UIViewController *)controllerDisplayedInDetailNavigationController
{
    UIViewController *returnController = nil;
    
    if (IS_IPAD)
    {
        UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        
        if ([rootViewController isKindOfClass:[ContainerViewController class]])
        {
            ContainerViewController *containerViewController = (ContainerViewController *)rootViewController;
            RootRevealControllerViewController *splitViewController = (RootRevealControllerViewController *)containerViewController.rootViewController;
            UIViewController *rootDetailController = splitViewController.detailViewController;
            if ([rootDetailController isKindOfClass:[DetailSplitViewController class]])
            {
                DetailSplitViewController *rootDetailSplitViewController = (DetailSplitViewController *)rootDetailController;
                UIViewController *controllerInRootDetailSplitViewController = rootDetailSplitViewController.detailViewController;
                
                if ([controllerInRootDetailSplitViewController isKindOfClass:[NavigationViewController class]])
                {
                    NavigationViewController *detailNavigationViewController = (NavigationViewController *)controllerInRootDetailSplitViewController;
                    returnController = [detailNavigationViewController.viewControllers lastObject];
                }
            }
        }
    }
    
    return returnController;
}

+ (NSString *)detailViewItemIdentifier
{
    id detailViewController = [self controllerDisplayedInDetailNavigationController];
    
    if ([detailViewController conformsToProtocol:@protocol(ItemInDetailViewProtocol)])
    {
        return [detailViewController detailViewItemIdentifier];
    }
    
    return nil;
}

+ (UIViewController *)containerViewController
{
    ContainerViewController *rootViewController = (ContainerViewController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    return rootViewController;
}

+ (UIViewController *)revealViewController
{
    ContainerViewController *rootViewController = (ContainerViewController *)[self containerViewController];
    return rootViewController.rootViewController;
}

+ (UIViewController *)rootMasterViewController
{
    RootRevealControllerViewController *rootViewController = (RootRevealControllerViewController *)[self revealViewController];
    return rootViewController.masterViewController;
}

+ (UIViewController *)rootDetailViewController
{
    RootRevealControllerViewController *rootViewController = (RootRevealControllerViewController *)[self revealViewController];
    return rootViewController.detailViewController;
}

@end
