//
//  DocumentPreviewViewController.m
//  AlfrescoApp
//
//  Created by Tauseef Mughal on 07/10/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "DocumentPreviewViewController.h"
#import "ActionCollectionView.h"
#import "ThumbnailDownloader.h"
#import "MBProgressHUD.h"
#import "ErrorDescriptions.h"
#import "UniversalDevice.h"
#import "MetaDataViewController.h"
#import "VersionHistoryViewController.h"
#import "PagedScrollView.h"
#import "CommentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FavouriteManager.h"
#import "DownloadManager.h"
#import "SyncManager.h"
#import "UIAlertView+ALF.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ActionViewHandler.h"
#import "FilePreviewViewController.h"

@interface DocumentPreviewViewController () <ActionCollectionViewDelegate, PagedScrollViewDelegate, CommentViewControllerDelegate, ActionViewDelegate>

@end

@implementation DocumentPreviewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.document.name;
    
    // collection view
    [self setupActionCollectionView];
    
    // setup the paging view
    [self setupPagingScrollView];
    
    // localise the UI
    [self localiseUI];
    
    [self updateActionButtons];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateActionButtons)
                                                 name:kFavoritesListUpdatedNotification
                                               object:nil];
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (!IS_IPAD)
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - Private Functions

- (void)showHUD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.progressHUD)
        {
            self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:self.progressHUD];
        }
        [self.progressHUD show:YES];
    });
}

- (void)hideHUD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressHUD hide:YES];
    });
}

- (void)setupPagingScrollView
{
    FilePreviewViewController *filePreviewController = nil;
    if (self.documentLocation == InAppDocumentLocationLocalFiles || self.documentLocation == InAppDocumentLocationSync)
    {
        filePreviewController = [[FilePreviewViewController alloc] initWithFilePath:self.documentContentFilePath document:self.document loadingCompletionBlock:nil];
    }
    else
    {
        filePreviewController = [[FilePreviewViewController alloc] initWithDocument:self.document session:self.session];
    }
    MetaDataViewController *metaDataController = [[MetaDataViewController alloc] initWithAlfrescoNode:self.document session:self.session];
    VersionHistoryViewController *versionHistoryController = [[VersionHistoryViewController alloc] initWithDocument:self.document session:self.session];
    CommentViewController *commentViewController = [[CommentViewController alloc] initWithAlfrescoNode:self.document permissions:self.documentPermissions session:self.session delegate:self];
    
    for (int i = 0; i < PagingScrollViewSegmentType_MAX; i++)
    {
        [self.pagingControllers addObject:[NSNull null]];
    }
    
    [self.pagingControllers insertObject:filePreviewController atIndex:PagingScrollViewSegmentTypeFilePreview];
    [self.pagingControllers insertObject:metaDataController atIndex:PagingScrollViewSegmentTypeMetadata];
    [self.pagingControllers insertObject:versionHistoryController atIndex:PagingScrollViewSegmentTypeVersionHistory];
    [self.pagingControllers insertObject:commentViewController atIndex:PagingScrollViewSegmentTypeComments];
    
    for (int i = 0; i < self.pagingControllers.count; i++)
    {
        if (![self.pagingControllers[i] isKindOfClass:[NSNull class]])
        {
            UIViewController *currentController = self.pagingControllers[i];
            [self addChildViewController:currentController];
            [self.pagingScrollView addSubview:currentController.view];
            [currentController didMoveToParentViewController:self];
        }
    }
}

- (void)updateActionButtons
{
    // check node is favourited
    [[FavouriteManager sharedManager] isNodeFavorite:self.document session:self.session completionBlock:^(BOOL isFavorite, NSError *error) {
        if (isFavorite)
        {
            NSDictionary *userInfo = @{kActionCollectionItemUpdateItemIndentifier : kActionCollectionIdentifierUnfavourite,
                                       kActionCollectionItemUpdateItemTitleKey : NSLocalizedString(@"action.unfavourite", @"Unfavourite Action"),
                                       kActionCollectionItemUpdateItemImageKey : @"actionsheet-favourited.png"};
            [[NSNotificationCenter defaultCenter] postNotificationName:kActionCollectionItemUpdateNotification object:kActionCollectionIdentifierFavourite userInfo:userInfo];
        }
        else
        {
            NSDictionary *userInfo = @{kActionCollectionItemUpdateItemIndentifier : kActionCollectionIdentifierFavourite,
                                       kActionCollectionItemUpdateItemTitleKey : NSLocalizedString(@"action.favourite", @"Favourite Action"),
                                       kActionCollectionItemUpdateItemImageKey : @"actionsheet-unfavourited.png"};
            [[NSNotificationCenter defaultCenter] postNotificationName:kActionCollectionItemUpdateNotification object:kActionCollectionIdentifierUnfavourite userInfo:userInfo];
        }
    }];
    
    // check and update the like node
    [self.ratingService isNodeLiked:self.document completionBlock:^(BOOL succeeded, BOOL isLiked, NSError *error) {
        if (succeeded && isLiked)
        {
            NSDictionary *userInfo = @{kActionCollectionItemUpdateItemIndentifier : kActionCollectionIdentifierUnlike,
                                       kActionCollectionItemUpdateItemTitleKey : NSLocalizedString(@"action.unlike", @"Unlike Action"),
                                       kActionCollectionItemUpdateItemImageKey : @"actionsheet-liked.png"};
            [[NSNotificationCenter defaultCenter] postNotificationName:kActionCollectionItemUpdateNotification object:kActionCollectionIdentifierLike userInfo:userInfo];
        }
    }];
}

- (void)setupActionCollectionView
{
    BOOL isRestricted = NO;
    
    NSMutableArray *items = [NSMutableArray array];
    
    [items addObject:[ActionCollectionItem favouriteItem]];
    [items addObject:[ActionCollectionItem likeItem]];
    [items addObject:[ActionCollectionItem downloadItem]];
    
    if ([self.session isKindOfClass:[AlfrescoRepositorySession class]])
    {
        // We do not currently support creating or querying workflows for Alfresco in the cloud
        [items addObject:[ActionCollectionItem sendForReview]];
    }

    if (self.documentPermissions.canEdit)
    {
       NSArray *editableDocumentExtensions = [kEditableDocumentExtensions componentsSeparatedByString:@","];
       NSArray *editableDocumentMimeTypes = [kEditableDocumentMimeTypes componentsSeparatedByString:@","];
            
       if ([editableDocumentExtensions containsObject:self.document.name.pathExtension] ||
           [editableDocumentMimeTypes containsObject:self.document.contentMimeType] ||
           [self.document.contentMimeType hasPrefix:@"text/"])
       {
           [items addObject:[ActionCollectionItem editItem]];
       }
    }
    
    if (self.documentPermissions.canComment)
    {
        [items addObject:[ActionCollectionItem commentItem]];
    }
    
    if (!isRestricted)
    {
        if ([MFMailComposeViewController canSendMail])
        {
            [items addObject:[ActionCollectionItem emailItem]];
        }
        
        if (![Utility isAudioOrVideo:self.document.name])
        {
            [items addObject:[ActionCollectionItem printItem]];
        }
        
        [items addObject:[ActionCollectionItem openInItem]];
    }
    
    if (self.documentPermissions.canDelete)
    {
        [items addObject:[ActionCollectionItem deleteItem]];
    }
    
    self.actionMenuView.items = items;
}

#pragma mark - ActionCollectionViewDelegate Functions

- (void)didPressActionItem:(ActionCollectionItem *)actionItem cell:(UICollectionViewCell *)cell inView:(UICollectionView *)view
{
    if ([actionItem.itemIdentifier isEqualToString:kActionCollectionIdentifierLike])
    {
        [self.actionHandler pressedLikeActionItem:actionItem];
    }
    else if ([actionItem.itemIdentifier isEqualToString:kActionCollectionIdentifierUnlike])
    {
        [self.actionHandler pressedUnlikeActionItem:actionItem];
    }
    else if ([actionItem.itemIdentifier isEqualToString:kActionCollectionIdentifierFavourite])
    {
        [self.actionHandler pressedFavouriteActionItem:actionItem];
    }
    else if ([actionItem.itemIdentifier isEqualToString:kActionCollectionIdentifierUnfavourite])
    {
        [self.actionHandler pressedUnfavouriteActionItem:actionItem];
    }
    else if ([actionItem.itemIdentifier isEqualToString:kActionCollectionIdentifierEmail])
    {
        [self.actionHandler pressedEmailActionItem:actionItem documentPath:self.documentContentFilePath documentLocation:self.documentLocation];
    }
    else if ([actionItem.itemIdentifier isEqualToString:kActionCollectionIdentifierDownload])
    {
        [self.actionHandler pressedDownloadActionItem:actionItem];
    }
    else if ([actionItem.itemIdentifier isEqualToString:kActionCollectionIdentifierComment])
    {
        self.pagingSegmentControl.selectedSegmentIndex = PagingScrollViewSegmentTypeComments;
        [self.pagingScrollView scrollToDisplayViewAtIndex:PagingScrollViewSegmentTypeComments animated:YES];
        CommentViewController *commentsViewController = [self.pagingControllers objectAtIndex:PagingScrollViewSegmentTypeComments];
        [commentsViewController focusCommentEntry];
    }
    else if ([actionItem.itemIdentifier isEqualToString:kActionCollectionIdentifierPrint])
    {
        [self.actionHandler pressedPrintActionItem:actionItem documentPath:self.documentContentFilePath documentLocation:self.documentLocation presentFromView:cell inView:view];
    }
    else if ([actionItem.itemIdentifier isEqualToString:kActionCollectionIdentifierOpenIn])
    {
        [self.actionHandler pressedOpenInActionItem:actionItem documentPath:self.documentContentFilePath documentLocation:self.documentLocation presentFromView:cell inView:view];
    }
    else if ([actionItem.itemIdentifier isEqualToString:kActionCollectionIdentifierDelete])
    {
        [self.actionHandler pressedDeleteActionItem:actionItem];
    }
    else if ([actionItem.itemIdentifier isEqualToString:kActionCollectionIdentifierRename])
    {
        [self.actionHandler pressedRenameActionItem:actionItem atPath:self.documentContentFilePath];
    }
    else if ([actionItem.itemIdentifier isEqualToString:kActionCollectionIdentifierSendForReview])
    {
        [self.actionHandler pressedSendForReviewActionItem:actionItem node:self.document];
    }
    else if ([actionItem.itemIdentifier isEqualToString:kActionCollectionIdentifierEdit])
    {
        [self.actionHandler pressedEditActionItem:actionItem forDocumentWithContentPath:self.documentContentFilePath];
    }
}

#pragma mark - ActionViewHandlerDelegate Functions

- (void)displayProgressIndicator
{
    [self showHUD];
}

- (void)hideProgressIndicator
{
    [self hideHUD];
}

#pragma mark - PagedScrollViewDelegate Functions

- (void)pagedScrollViewDidScrollToFocusViewAtIndex:(NSInteger)viewIndex whilstDragging:(BOOL)dragging
{
    // only want to update the segment control on each call if we are swiping and not using the segemnt control
    if (dragging)
    {
        [self.pagingSegmentControl setSelectedSegmentIndex:viewIndex];
    }
}

#pragma mark - CommentViewControllerDelegate Functions

- (void)commentViewController:(CommentViewController *)controller didUpdateCommentCount:(NSUInteger)commentDisplayedCount hasMoreComments:(BOOL)hasMoreComments
{
    NSString *segmentCommentText = nil;
    
    if (hasMoreComments && commentDisplayedCount >= kMaxItemsPerListingRetrieve)
    {
        segmentCommentText = [NSString stringWithFormat:NSLocalizedString(@"document.segment.comments.hasmore.title", @"Comments Segment Title - Has More"), kMaxItemsPerListingRetrieve];
    }
    else if (commentDisplayedCount > 0)
    {
        segmentCommentText = [NSString stringWithFormat:NSLocalizedString(@"document.segment.comments.title", @"Comments Segment Title - Count"), commentDisplayedCount];
    }
    else
    {
        segmentCommentText = [self.pagingSegmentControl titleForSegmentAtIndex:PagingScrollViewSegmentTypeComments];
    }
    
    [self.pagingSegmentControl setTitle:segmentCommentText forSegmentAtIndex:PagingScrollViewSegmentTypeComments];
}

@end
