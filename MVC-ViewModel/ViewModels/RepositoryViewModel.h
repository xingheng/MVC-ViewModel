//
//  RepositoryViewModel.h
//  MVC-ViewModel
//
//  Created by WeiHan on 2022/6/6.
//

#import "RepositoryCollectionView.h"
#import "RepositoryModel.h"

#define DataItemInitializerDeclaration(_containing_cls_, _source_cls_)     \
    + (instancetype)dataItemWith ## _source_cls_: (_source_cls_ *)context; \
    + (instancetype)dataItemWith ## _source_cls_: (_source_cls_ *)context  \
         block: (void (^ _Nullable)(_source_cls_ *source, _containing_cls_ *data))block;     \
    + (NSArray<_containing_cls_ *> *)dataItemsWith ## _source_cls_ ## s:(NSArray<_source_cls_ *> *)context;                                \
    + (NSArray<_containing_cls_ *> *)dataItemsWith ## _source_cls_ ## s:(NSArray<_source_cls_ *> *)context                                 \
         block: (void (^ _Nullable)(_source_cls_ *source, _containing_cls_ *data))block;

#define DataItemInitializerImplementation(_containing_cls_, _source_cls_)                                    \
    + (instancetype)dataItemWith ## _source_cls_: (_source_cls_ *)context                                    \
    {                                                                                                        \
        return [self dataItemWith ## _source_cls_:context block:nil];                                        \
    }                                                                                                        \
    + (instancetype)dataItemWith ## _source_cls_: (_source_cls_ *)context                                    \
         block: (void (^ _Nullable)(_source_cls_ *source, _containing_cls_ *data))block                                        \
    {                                                                                                        \
        _containing_cls_ *data = [self new];                                                                 \
        data.context = context;                                                                              \
        if (block) {                                                                                         \
            block(context, data);                                                                            \
        }                                                                                                    \
        return data;                                                                                         \
    }                                                                                                        \
    + (NSArray<_containing_cls_ *> *)dataItemsWith ## _source_cls_ ## s:(NSArray<_source_cls_ *> *)context                                                                   \
    {                                                                                                        \
        return [self dataItemsWith ## _source_cls_ ## s:context block:nil];                                  \
    }                                                                                                        \
    + (NSArray<_containing_cls_ *> *)dataItemsWith ## _source_cls_ ## s:(NSArray<_source_cls_ *> *)context                                                                   \
         block: (void (^ _Nullable)(_source_cls_ *source, _containing_cls_ *data))block                                        \
    {                                                                                                        \
        NSMutableArray<_containing_cls_ *> *items = [[NSMutableArray alloc] initWithCapacity:context.count]; \
        for (_source_cls_ *c in context) {                                                                   \
            [items addObject:[self dataItemWith ## _source_cls_:c block:block]];                             \
        }                                                                                                    \
        return items;                                                                                        \
    }

#define DataItemGetterForward(_source_cls_, _expr_)        \
    if ([self.context isKindOfClass:_source_cls_.class]) { \
        return ((_source_cls_ *)self.context)._expr_;      \
    }

NS_ASSUME_NONNULL_BEGIN

@interface RepositoryViewModel : NSObject <RepositoryViewProtocol>

@property (nonatomic, strong) id context;

@property (nonatomic, assign) BOOL visited;

@property (nonatomic, copy) void (^ onRepositoryTapped)(void);

DataItemInitializerDeclaration(RepositoryViewModel, RepositoryModel)

@end

NS_ASSUME_NONNULL_END
