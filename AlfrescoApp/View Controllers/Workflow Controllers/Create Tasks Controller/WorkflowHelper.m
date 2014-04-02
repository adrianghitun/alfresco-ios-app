//
//  WorkflowHelper.m
//  AlfrescoApp
//
//  Created by Mohamad Saeedi on 02/04/2014.
//  Copyright (c) 2014 Alfresco. All rights reserved.
//

#import "WorkflowHelper.h"

static NSString * const kAlfrescoWorkflowActivitiEngine = @"activiti$";
static NSString * const kAlfrescoWorkflowJBPMEngine = @"jbpm$";

static NSString * const kAlfrescoActivitiWorkflowTypeAdhoc = @"activitiAdhoc";
static NSString * const kAlfrescoActivitiWorkflowTypeParallelReview = @"activitiParallelReview";
static NSString * const kAlfrescoActivitiWorkflowTypeReview = @"activitiReview";

static NSString * const kAlfrescoJBPMWorkflowTypeAdhoc = @"wf:Adhoc";
static NSString * const kAlfrescoJBPMWorkflowTypeParallelReview = @"wf:ParallelReview";
static NSString * const kAlfrescoJBPMWorkflowTypeReview = @"wf:Review";

@implementation WorkflowHelper

+ (NSString *)processDefinitionKeyForWorkflowType:(WorkflowType)workflowType session:(id<AlfrescoSession>)session
{
    NSString *processDefinitionKey = @"";
    
    BOOL doesSupportActivitiEngine = session.repositoryInfo.capabilities.doesSupportActivitiWorkflowEngine;
    BOOL doesSupportJBPMEngine = session.repositoryInfo.capabilities.doesSupportJBPMWorkflowEngine;
    
    if (workflowType == WorkflowTypeTodo)
    {
        processDefinitionKey = doesSupportJBPMEngine ?  kAlfrescoJBPMWorkflowTypeAdhoc : kAlfrescoActivitiWorkflowTypeAdhoc;
    }
    else if (workflowType == WorkflowTypeReview)
    {
        processDefinitionKey = doesSupportJBPMEngine ?  kAlfrescoJBPMWorkflowTypeReview : kAlfrescoActivitiWorkflowTypeReview;
    }
    else
    {
        processDefinitionKey = doesSupportJBPMEngine ?  kAlfrescoJBPMWorkflowTypeParallelReview : kAlfrescoActivitiWorkflowTypeParallelReview;
    }
    
    if (!session.repositoryInfo.capabilities.doesSupportPublicAPI)
    {
        if (doesSupportActivitiEngine)
        {
            processDefinitionKey = [kAlfrescoWorkflowActivitiEngine stringByAppendingString:processDefinitionKey];
        }
        else if (doesSupportJBPMEngine)
        {
            processDefinitionKey = [kAlfrescoWorkflowJBPMEngine stringByAppendingString:processDefinitionKey];
        }
    }
    
    return processDefinitionKey;
}

@end
