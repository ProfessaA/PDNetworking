#import <Foundation/Foundation.h>


@protocol PDRetrievalClient <NSObject>

- (KSPromise *)retrievalPromiseWithRequestParameters:(id)requestParameters;

@end
