#import <Foundation/Foundation.h>


@class KSPromise;


@protocol PDDeletionClient <NSObject>

- (KSPromise *)deletionPromiseWithRequestParameters:(id)requestParameters;

@end
