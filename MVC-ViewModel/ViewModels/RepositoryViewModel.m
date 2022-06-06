//
//  RepositoryViewModel.m
//  MVC-ViewModel
//
//  Created by WeiHan on 2022/6/6.
//

#import "RepositoryViewModel.h"

@implementation RepositoryViewModel

DataItemInitializerImplementation(RepositoryViewModel, RepositoryModel)

- (NSString *)title
{
    DataItemGetterForward(RepositoryModel, full_name)
    return nil;
}

- (NSString *)subtitle
{
    DataItemGetterForward(RepositoryModel, descriptions)
    return nil;
}

@end
