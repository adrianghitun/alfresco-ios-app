//
//  DownloadsDocumentPreviewViewController.m
//  AlfrescoApp
//
//  Created by Tauseef Mughal on 14/04/2014.
//  Copyright (c) 2014 Alfresco. All rights reserved.
//

#import "DownloadsDocumentPreviewViewController.h"
#import "FilePreviewViewController.h"
#import "MetaDataViewController.h"

@interface DownloadsDocumentPreviewViewController ()

@property (nonatomic, strong) NSMutableArray *displayedPagingControllers;

@end

@implementation DownloadsDocumentPreviewViewController

- (instancetype)initWithAlfrescoDocument:(AlfrescoDocument *)document
                             permissions:(AlfrescoPermissions *)permissions
                         contentFilePath:(NSString *)contentFilePath
                        documentLocation:(InAppDocumentLocation)documentLocation
                                 session:(id<AlfrescoSession>)session
{
    self = [super initWithAlfrescoDocument:document permissions:permissions contentFilePath:contentFilePath documentLocation:documentLocation session:session];
    if (self)
    {
        self.pagingControllers = [NSMutableArray array];
        self.displayedPagingControllers = [NSMutableArray array];
        self.actionHandler = [[ActionViewHandler alloc] initWithAlfrescoNode:nil session:nil controller:self];
    }
    return self;
}

- (instancetype)initWithFilePath:(NSString *)filePath
{
    self = [self initWithNibName:@"BaseDocumentPreviewViewController" bundle:nil];
    if (self)
    {
        self.documentContentFilePath = filePath;
        self.documentLocation = InAppDocumentLocationLocalFiles;
        self.pagingControllers = [NSMutableArray array];
        self.displayedPagingControllers = [NSMutableArray array];
        self.actionHandler = [[ActionViewHandler alloc] initWithAlfrescoNode:nil session:nil controller:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupPagingScrollView];
    [self refreshViewController];
}

- (void)refreshViewController
{
    self.title = (self.documentLocation == InAppDocumentLocationLocalFiles) ? self.documentContentFilePath.lastPathComponent : self.document.name;
    
    if (!self.document)
    {
        self.segmentControlHeightConstraint.constant = 0;
        self.pagingSegmentControl.hidden = YES;
    }
    
    [self refreshPagingScrollView];
    [self setupActionCollectionView];
    
    [self localiseUI];
}

- (void)localiseUI
{
    [self.pagingSegmentControl setTitle:NSLocalizedString(@"document.segment.preview.title", @"Preview Segment Title") forSegmentAtIndex:PagingScrollViewSegmentTypeFilePreview];
    [self.pagingSegmentControl setTitle:NSLocalizedString(@"document.segment.repository.metadata.title", @"Metadata Segment Title") forSegmentAtIndex:PagingScrollViewSegmentTypeMetadata];
}

- (void)setupPagingScrollView
{
    [self.pagingSegmentControl removeAllSegments];
    [self.pagingSegmentControl insertSegmentWithTitle:NSLocalizedString(@"document.segment.preview.title", @"Preview Segment Title") atIndex:PagingScrollViewSegmentTypeFilePreview animated:NO];
    [self.pagingSegmentControl insertSegmentWithTitle:NSLocalizedString(@"document.segment.repository.metadata.title", @"Metadata Segment Title") atIndex:PagingScrollViewSegmentTypeMetadata animated:NO];
    
    FilePreviewViewController *filePreviewController = [[FilePreviewViewController alloc] initWithFilePath:self.documentContentFilePath document:nil loadingCompletionBlock:nil];
    [self.pagingControllers insertObject:filePreviewController atIndex:PagingScrollViewSegmentTypeFilePreview];
    MetaDataViewController *metadataViewController = [[MetaDataViewController alloc] initWithAlfrescoNode:self.document session:nil];
    [self.pagingControllers insertObject:metadataViewController atIndex:PagingScrollViewSegmentTypeMetadata];
}

 - (void)refreshPagingScrollView
{
    NSUInteger currentlySelectedTabIndex = self.pagingScrollView.selectedPageIndex;
    
    // Remove all existing views in the scroll view
    NSArray *shownControllers = [NSArray arrayWithArray:self.displayedPagingControllers];
    
    for (UIViewController *displayedController in shownControllers)
    {
        [displayedController willMoveToParentViewController:nil];
        [displayedController.view removeFromSuperview];
        [displayedController removeFromParentViewController];
        
        [self.displayedPagingControllers removeObject:displayedController];
    }
    
    // Add them back and refresh the segment control.
    // If the document object is nil, we must not disiplay the MetaDataViewController
    for (UIViewController *pagingController in self.pagingControllers)
    {
        if (self.document == nil && [pagingController isKindOfClass:[MetaDataViewController class]])
        {
            break;
        }
        [self addChildViewController:pagingController];
        [self.pagingScrollView addSubview:pagingController.view];
        [pagingController didMoveToParentViewController:self];
        
        [self.displayedPagingControllers addObject:pagingController];
    }
    
    self.pagingSegmentControl.selectedSegmentIndex = currentlySelectedTabIndex;
    [self.pagingScrollView scrollToDisplayViewAtIndex:currentlySelectedTabIndex animated:NO];
}

- (void)setupActionCollectionView
{
    BOOL isRestricted = NO;
    
    NSMutableArray *items = [NSMutableArray array];

    if (self.documentLocation == InAppDocumentLocationLocalFiles)
    {
        [items addObject:[ActionCollectionItem renameItem]];
    }
    
    if (!isRestricted)
    {
        if ([MFMailComposeViewController canSendMail])
        {
            [items addObject:[ActionCollectionItem emailItem]];
        }
        
        if (![Utility isAudioOrVideo:self.documentContentFilePath])
        {
            [items addObject:[ActionCollectionItem printItem]];
        }
        
        [items addObject:[ActionCollectionItem openInItem]];
    }
    
    if (self.documentLocation == InAppDocumentLocationLocalFiles)
    {
        [items addObject:[ActionCollectionItem deleteItem]];
    }
    
    self.actionMenuView.items = items;
}

#pragma mark - ActionCollectionViewDelegate Functions

- (void)didPressActionItem:(ActionCollectionItem *)actionItem cell:(UICollectionViewCell *)cell inView:(UICollectionView *)view
{
    if ([actionItem.itemIdentifier isEqualToString:kActionCollectionIdentifierEmail])
    {
        [self.actionHandler pressedEmailActionItem:actionItem documentPath:self.documentContentFilePath documentLocation:self.documentLocation];
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
        [self.actionHandler pressedDeleteLocalFileActionItem:actionItem documentPath:self.documentContentFilePath];
    }
    else if ([actionItem.itemIdentifier isEqualToString:kActionCollectionIdentifierRename])
    {
        [self.actionHandler pressedRenameActionItem:actionItem atPath:self.documentContentFilePath];
    }
}

#pragma mark - NodeUpdatableProtocal Functions

- (void)updateToAlfrescoDocument:(AlfrescoDocument *)node
                     permissions:(AlfrescoPermissions *)permissions
                 contentFilePath:(NSString *)contentFilePath
                documentLocation:(InAppDocumentLocation)documentLocation
                         session:(id<AlfrescoSession>)session
{
    self.document = node;
    self.documentContentFilePath = contentFilePath;
    self.documentLocation = documentLocation;
    self.session = session;
    
    self.actionHandler.node = node;
    self.actionHandler.session = session;
    
    [self refreshViewController];
    
    for (UIViewController *pagingController in self.displayedPagingControllers)
    {
        if ([pagingController conformsToProtocol:@protocol(NodeUpdatableProtocol)])
        {
            UIViewController<NodeUpdatableProtocol> *conformingController = (UIViewController<NodeUpdatableProtocol> *)pagingController;
            if ([conformingController respondsToSelector:@selector(updateToAlfrescoDocument:permissions:contentFilePath:documentLocation:session:)])
            {
                [conformingController updateToAlfrescoDocument:node permissions:permissions contentFilePath:contentFilePath documentLocation:documentLocation session:session];
            }
            else if ([conformingController respondsToSelector:@selector(updateToAlfrescoNode:permissions:session:)])
            {
                [conformingController updateToAlfrescoNode:node permissions:permissions session:session];
            }
        }
    }
}

@end
