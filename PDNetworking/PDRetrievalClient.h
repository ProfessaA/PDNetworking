#import <Foundation/Foundation.h>


@protocol PDRetrievalClient <NSObject>

- (KSPromise *)retrievalClientPromiseWithRequestParameters:(id)requestParameters;

@end
