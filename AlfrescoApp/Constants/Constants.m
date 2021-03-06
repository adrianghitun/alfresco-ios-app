/*******************************************************************************
 * Copyright (C) 2005-2014 Alfresco Software Limited.
 * 
 * This file is part of the Alfresco Mobile iOS App.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *  
 *  http://www.apache.org/licenses/LICENSE-2.0
 * 
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 ******************************************************************************/
 
#import "Constants.h"

// Time delay used in workaround for Cloud API rate limiting issues (comments and version history requests)
NSTimeInterval const kRateLimitForRequestsOnCloud = 1.0;

int const kMaxItemsPerListingRetrieve = 25;

NSString * const kLicenseDictionaries = @"thirdPartyLibraries";

NSString * const kSmallThumbnailImageMappingPlist = @"SmallThumbnailImageMapping";
NSString * const kLargeThumbnailImageMappingPlist = @"LargeThumbnailImageMapping";

NSString * const kRenditionImageDocLib = @"doclib";
NSString * const kRenditionImageImagePreview = @"imgpreview";

NSString * const kRepositoryEditionEnterprise = @"Enterprise";
NSString * const kRepositoryEditionCommunity = @"Community";

NSString * const kEditableDocumentExtensions = @"txt,htm,html,xml,css,js,ftl,java,properties";
// In addition, all "text/..." mimetypes are allowed to be edited
NSString * const kEditableDocumentMimeTypes = @"application/xml,application/javascript";

// "No Files" font size
CGFloat const kEmptyListLabelFontSize = 24.0f;

// App RevealController
CGFloat const kRevealControllerMasterViewWidth = 300.0f;

// NSUserDefaults Keys
NSString * const kIsAppFirstLaunch = @"IsAppFirstLaunch";

// App Configuration
NSString * const kAppConfigurationFileLocationOnServer = @"Mobile/configuration.json";
NSString * const kAppConfigurationActivitiesKey = @"com.alfresco.activities";
NSString * const kAppConfigurationFavoritesKey = @"com.alfresco.favorites";
NSString * const kAppConfigurationLocalFilesKey = @"com.alfresco.localFiles";
NSString * const kAppConfigurationNotificationsKey = @"com.alfresco.notifications";
NSString * const kAppConfigurationRepositoryKey = @"com.alfresco.repository";
NSString * const kAppConfigurationSearchKey = @"com.alfresco.search";
NSString * const kAppConfigurationSitesKey = @"com.alfresco.sites";
NSString * const kAppConfigurationTasksKey = @"com.alfresco.tasks";
NSString * const kAppConfigurationMyFilesKey = @"com.alfresco.repository.userhome";
NSString * const kAppConfigurationSharedFilesKey = @"com.alfresco.repository.shared";

// App Configuration Notifications
NSString * const kAlfrescoAppConfigurationUpdatedNotification = @"AlfrescoAppConfigurationUpdatedNotification";

// Request Handler
NSInteger const kRequestTimeOutInterval = 60;
NSString * const kProtocolHTTP = @"http";
NSString * const kProtocolHTTPS = @"https";
NSString * const kHTTPMethodPOST = @"POST";
NSString * const kHTTPMethodGET = @"GET";

// Notifications
NSString * const kAlfrescoSessionReceivedNotification = @"AlfrescoSessionReceivedNotification";
NSString * const kAlfrescoSiteRequestsCompletedNotification = @"AlfrescoSiteRequestsCompleted";
NSString * const kAlfrescoAccessDeniedNotification = @"AlfrescoUnauthorizedAccessNotification";
NSString * const kAlfrescoApplicationPolicyUpdatedNotification = @"AlfrescoApplicationPolicyUpdatedNotification";
NSString * const kAlfrescoDocumentDownloadedNotification = @"AlfrescoDocumentDownloadedNotification";
NSString * const kAlfrescoConnectivityChangedNotification = @"AlfrescoConnectivityChangedNotification";
NSString * const kAlfrescoDocumentUpdatedOnServerNotification = @"AlfrescoDocumentUpdatedOnServerNotification";
NSString * const kAlfrescoDocumentUpdatedLocallyNotification = @"AlfrescoDocumentUpdatedLocallyNotification";
NSString * const kAlfrescoDocumentDeletedOnServerNotification = @"AlfrescoDocumentDeletedOnServerNotification";
NSString * const kAlfrescoNodeAddedOnServerNotification = @"AlfrescoNodeAddedOnServerNotification";
NSString * const kAlfrescoDocumentUpdatedFromDocumentParameterKey = @"AlfrescoDocumentUpdatedFromDocumentParameterKey";
NSString * const kAlfrescoDocumentUpdatedFilenameParameterKey = @"AlfrescoDocumentUpdatedFilenameParameterKey";
NSString * const kAlfrescoDocumentDownloadedIdentifierKey = @"AlfrescoDocumentDownloadedIdentifierKey";
NSString * const kAlfrescoNodeAddedOnServerParentFolderKey = @"AlfrescoNodeAddedOnServerParentFolderKey";
NSString * const kAlfrescoNodeAddedOnServerSubNodeKey = @"AlfrescoNodeAddedOnServerSubNodeKey";
NSString * const kAlfrescoNodeAddedOnServerContentLocationLocally = @"AlfrescoNodeAddedOnServerContentLocationLocally";
NSString * const kAlfrescoWorkflowTaskListDidChangeNotification = @"AlfrescoWorkflowTaskListDidChange";
NSString * const kAlfrescoDocumentEditedNotification = @"AlfrescoDocumentEditedNotification";
// Saveback
NSString * const kAlfrescoSaveBackLocalComplete = @"AlfrescoSaveBackLocalComplete";
NSString * const kAlfrescoSaveBackRemoteComplete = @"AlfrescoSaveBackRemoteComplete";

// Accounts
NSString * const kAlfrescoAccountAddedNotification = @"AlfrescoAccountAddedNotification";
NSString * const kAlfrescoAccountRemovedNotification = @"AlfrescoAccountRemovedNotification";
NSString * const kAlfrescoAccountUpdatedNotification = @"AlfrescoAccountUpdatedNotification";
NSString * const kAlfrescoAccountsListEmptyNotification = @"AlfrescoAccountsListEmptyNotification";
NSString * const kAlfrescoFirstPaidAccountAddedNotification = @"AlfrescoFirstPaidAccountAddedNotification";
NSString * const kAlfrescoLastPaidAccountRemovedNotification = @"AlfrescoLastPaidAccountRemovedNotification";

// Application policy constants
NSString * const kApplicationPolicySettings = @"ApplicationPolicySettings";
NSString * const kApplicationPolicyAudioVideo = @"ApplicationPolicyAudioVideo";
NSString * const kApplicationPolicyServer = @"ApplicationPolicySettingServer";
NSString * const kApplicationPolicyUsernameGenerationFormat = @"ApplicationPolicySettingUsernameGenerationFormat";
NSString * const kApplicationPolicyServerDisplayName = @"ApplicationPolicySettingServerDisplayName";
NSString * const kApplicationPolicySettingAudioEnabled = @"ApplicationPolicySettingAudioEnabled";
NSString * const kApplicationPolicySettingVideoEnabled = @"ApplicationPolicySettingVideoEnabled";

// Sync
NSString * const kSyncObstaclesKey = @"syncObstacles";
NSInteger const kDefaultMaximumAllowedDownloadSize = 20 * 1024 * 1024; // 20 MB
NSString * const kSyncPreference = @"SyncNodes";
NSString * const kSyncOnCellular = @"SyncOnCellular";

// Sync Notification constants
NSString * const kSyncStatusChangeNotification = @"kSyncStatusChangeNotification";
NSString * const kSyncObstaclesNotification = @"kSyncObstaclesNotification";
NSString * const kFavoritesListUpdatedNotification = @"kFavoritesListUpdatedNotification";
NSString * const kSyncProgressViewVisiblityChangeNotification = @"kSyncProgressViewVisiblityChangeNotification";

// Download Notifictations
NSString * const kDocumentPreviewManagerWillStartDownloadNotification = @"DocumentPreviewManagerWillStartDownloadNotification";
NSString * const kDocumentPreviewManagerProgressNotification = @"DocumentPreviewManagerProgressNotification";
NSString * const kDocumentPreviewManagerDocumentDownloadCompletedNotification = @"DocumentPreviewManagerDocumentDownloadCompletedNotification";
NSString * const kDocumentPreviewManagerDocumentDownloadCancelledNotification = @"DocumentPreviewManagerDocumentDownloadCancelledNotification";
NSString * const kDocumentPreviewManagerWillStartLocalDocumentDownloadNotification = @"DocumentPreviewManagerWillStartLocalDocumentDownloadNotification";

// Download Notification Keys
NSString * const kDocumentPreviewManagerDocumentIdentifierNotificationKey = @"DocumentPreviewManagerDocumentIdentifierNotificationKey";
NSString * const kDocumentPreviewManagerProgressBytesRecievedNotificationKey = @"DocumentPreviewManagerProgressBytesRecievedNotificationKey";
NSString * const kDocumentPreviewManagerProgressBytesTotalNotificationKey = @"DocumentPreviewManagerProgressBytesTotalNotificationKey";

// Local Files Notification
NSString * const kAlfrescoLocalDocumentNewName = @"AlfrescoLocalDocumentNewName";
NSString * const kAlfrescoDeleteLocalDocumentNotification = @"AlfrescoDeleteDocumentFileNotification";
NSString * const kAlfrescoLocalDocumentRenamedNotification = @"AlfrescoLocalDocumentRenamedNotification";

// Confirmation Options
NSUInteger const kConfirmationOptionYes = 0;
NSUInteger const kConfirmationOptionNo = 1;

// User settings keychain constants
NSString * const kApplicationRepositoryUsername = @"ApplictionRepositoryUsername";
NSString * const kApplicationRepositoryPassword = @"ApplictionRepositoryPassword";

// The maximum number of file suffixes that are attempted to avoid file overwrites
NSUInteger const kFileSuffixMaxAttempts = 1000;

// Custom NSError codes (use Bundle Identifier for error domain)
NSInteger const kErrorFileSuffixMaxAttempts = 101;

// Upload image quality setting
CGFloat const kUploadJPEGCompressionQuality = 1.0f;

// MultiSelect Actions
NSString * const kMultiSelectDelete = @"deleteAction";

// Pickers
CGFloat const kPickerMultiSelectToolBarHeight = 44.0f;

// Favourites notifications
NSString * const kFavouritesDidAddNodeNotification = @"FavouritesDidAddNodeNotification";
NSString * const kFavouritesDidRemoveNodeNotification = @"FavouritesDidRemoveNodeNotification";

// Cache
NSInteger const kNumberOfDaysToKeepCachedData = 7;

NSString * const kAlfrescoOnPremiseServerURLTemplate = @"%@://%@:%@/alfresco";

// Cloud Configuration
NSString * const kCloudConfigFile = @"cloud-config.plist";
NSString * const kCloudConfigParamURL = @"oauth_url";
NSString * const kCloudConfigParamAPIKey = @"apikey";
NSString * const kCloudConfigParamSecretKey = @"apisecret";
NSString * const kInternalSessionCloudURL = @"org.alfresco.mobile.internal.session.cloud.url";

// Cloud Sign Up
NSString * const kCloudAPIHeaderKey = @"key";
NSString * const kAlfrescoCloudAPISignUpUrl = @"https://a.alfresco.me/alfresco/a/-default-/internal/cloud/accounts/signupqueue";
NSString * const kAlfrescoCloudTermOfServiceUrl = @"http://www.alfresco.com/legal/agreements/cloud/";
NSString * const kAlfrescoCloudPrivacyPolicyUrl = @"http://www.alfresco.com/privacy/";
NSString * const kAlfrescoCloudCustomerCareUrl = @"https://getsatisfaction.com/alfresco/products/alfresco_alfresco_mobile_app";

// Cloud Account Status
NSString * const kCloudAccountIdValuePath = @"registration.id";
NSString * const kCloudAccountKeyValuePath = @"registration.key";
NSString * const kCloudAccountStatusValuePath = @"isActivated";
NSString * const kAlfrescoCloudAPIAccountStatusUrl = @"https://a.alfresco.me/alfresco/a/-default-/internal/cloud/accounts/signupqueue/{AccountId}?key={AccountKey}";
NSString * const kAlfrescoCloudAPIAccountKey = @"{AccountKey}";
NSString * const kAlfrescoCloudAPIAccountID = @"{AccountId}";

// Help/Documentation
NSString * const kAlfrescoHelpURLString = @"http://www.alfresco.com/";

// Workflow
NSString * const kAlfrescoWorkflowActivitiEngine = @"activiti$";
NSString * const kAlfrescoWorkflowJBPMEngine = @"jbpm$";
NSString * const kJBPMReviewTask = @"wf:reviewTask";
NSString * const kActivitiReviewTask = @"wf:activitiReviewTask";

// Google Quickoffice
NSString * const kQuickofficeApplicationSecretUUIDKey = @"PartnerApplicationSecretUUID";
NSString * const kQuickofficeApplicationInfoKey = @"PartnerApplicationInfo";
NSString * const kQuickofficeApplicationIdentifierKey = @"PartnerApplicationIdentifier";
NSString * const kQuickofficeApplicationDocumentExtension = @"alf01";
NSString * const kQuickofficeApplicationDocumentExtensionKey = @"PartnerApplicationDocumentExtension";
NSString * const kQuickofficeApplicationDocumentUTI = @"com.alfresco.mobile.qpa";
NSString * const kQuickofficeApplicationDocumentUTIKey = @"PartnerApplicationDocumentUTI";
// Custom
NSString * const kQuickofficeApplicationBundleIdentifierPrefix = @"com.quickoffice.";
NSString * const kAlfrescoInfoMetadataKey = @"AlfrescoInfoMetadataKey";
NSString * const kAppIdentifier = @"AlfrescoMobileApp";
