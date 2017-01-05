//
//  HLMacro.h
//  onlyforyou
//
//  Created by honghao5 on 17/1/4.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#ifndef HLMacro_h
#define HLMacro_h

#define ScreenBounds [UIScreen mainScreen].bounds

#define SYNTHESIZE_SINGLETON_FOR_HEADER(classname)\
+ (classname *)shared##classname;

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[super allocWithZone:NULL] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
return [self shared##classname];\
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
} \
\

#define RGBA(r, g, b, a) \
[UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#endif /* HLMacro_h */
