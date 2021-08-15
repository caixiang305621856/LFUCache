//
//  ACLFUCache.m
//  Cache
//
//  Created by caixiang on 2021/8/14.
//

#import "ACLFUCache.h"
#import <pthread.h>
#import <UIKit/UIKit.h>
#import "ACDoubleLinkedList.h"
#import "ACLinkedNode.h"

@interface ACLFUCache() {
    pthread_mutex_t _lock;
}

@property NSUInteger count;
/// 当前最小频率
@property NSUInteger minFreq;
/// key和数据节点的映射
@property (strong, nonatomic) NSMapTable <id, ACLinkedNode *>*map;
/// 频率和数据组成的链表的映射
@property (strong, nonatomic) NSMutableDictionary <NSNumber *,ACDoubleLinkedList*>*freqMap;

@end

@implementation ACLFUCache

- (instancetype)init {
    self = [super init];
    if (self) {
        self.countLimit = NSUIntegerMax;
        [self setup];
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)capacity {
    self = [super init];
    if (self) {
        self.countLimit = capacity;
        [self setup];
    }
    return self;
}

- (void)setup {
    pthread_mutex_init(&_lock, NULL);
    self.minFreq = 1;
    self.map = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsStrongMemory capacity:0];
    self.freqMap = [NSMutableDictionary new];
    self.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    self.shouldRemoveAllObjectsOnMemoryWarning = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_appDidReceiveMemoryWarningNotification) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_appDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)_appDidReceiveMemoryWarningNotification {
    if (self.didReceiveMemoryWarningBlock) {
        self.didReceiveMemoryWarningBlock(self);
    }
    if (self.shouldRemoveAllObjectsOnMemoryWarning) {
        [self removeAllObjects];
    }
}

- (void)_appDidEnterBackgroundNotification {
    if (self.didEnterBackgroundBlock) {
        self.didEnterBackgroundBlock(self);
    }
    if (self.shouldRemoveAllObjectsWhenEnteringBackground) {
        [self removeAllObjects];
    }
}


#pragma mark - public
- (BOOL)containsObjectForKey:(id)key {
    if (!key) return NO;
    pthread_mutex_lock(&_lock);    
    BOOL contains = [self.map.keyEnumerator.allObjects containsObject:key];
    pthread_mutex_unlock(&_lock);
    return contains;
}

- (nullable id)objectForKey:(id)key {
    if (!key) return nil;
    pthread_mutex_lock(&_lock);
    ACLinkedNode *node = [self.map objectForKey:key];
    if (node) {
        //增加数据的访问频率
        [self freqPlus:node];
    }
    pthread_mutex_unlock(&_lock);
    return node?node.value:nil;
}

- (void)setObject:(nullable id)object forKey:(id)key {
    if (!key) return;
    if (_countLimit <= 0) return;
    if (!object) {
        [self removeObjectForKey:key];
        return;
    }
    pthread_mutex_lock(&_lock);
    ACLinkedNode *node = [self.map objectForKey:key];
    if (node != nil) {
        node.value = object;
        //增加数据的访问频率
        [self freqPlus:node];
    } else{
        //淘汰数据
        [self eliminate];
        // 新增加数据放到数据频率为1的链表中
        ACLinkedNode *newNode = [[ACLinkedNode alloc] initWithKey:key value:object frequency:1];
        NSNumber *minFreq = @1;
        [self.map setObject:newNode forKey:key];
        ACDoubleLinkedList *linkList = self.freqMap[minFreq];
        if (linkList == nil) {
            linkList = [[ACDoubleLinkedList alloc] init];
            [self.freqMap setObject:linkList forKey:minFreq];
        }
        [linkList insertNodeAtHead:newNode];
        self.minFreq = 1;
        _count ++;
    }
    pthread_mutex_unlock(&_lock);
}

- (void)removeObjectForKey:(id)key {
    if (!key) return;
    pthread_mutex_lock(&_lock);
    ACLinkedNode *node = [self.map objectForKey:key];
    if (node) {
        [self.map removeObjectForKey:node.key];
        //取出要被删除的node 频次对应的 linkList
        ACDoubleLinkedList *linkList = self.freqMap[@(node.frequency)];
        //删除对应的node
        [linkList removeNode:node];
        if ([linkList isEmpty]) {
            //移除频次对应的 双向链表
            [self.freqMap removeObjectForKey:@(node.frequency)];
        }
        _count --;
    }
    pthread_mutex_unlock(&_lock);
}

- (void)removeAllObjects {
    pthread_mutex_lock(&_lock);
    _count = 0;
    self.minFreq = 1;
    [self.map removeAllObjects];
    [self.freqMap removeAllObjects];
    pthread_mutex_unlock(&_lock);
}

- (NSArray *)allkeys {
    pthread_mutex_lock(&_lock);
    NSArray *result = self.map.keyEnumerator.allObjects;
    pthread_mutex_unlock(&_lock);
    return result;
}

- (NSArray *)allValues {
    NSMutableArray *result = [NSMutableArray array];
    pthread_mutex_lock(&_lock);
    NSEnumerator *objectEnumerator = self.map.objectEnumerator;
    for (ACLinkedNode *obj in objectEnumerator.allObjects) {
        if (obj.value) {
            [result addObject:obj.value];
        }
    }
    pthread_mutex_unlock(&_lock);
    return result;
}

#pragma mark - private
/// 增加访问频率
- (void)freqPlus:(ACLinkedNode *)node {
    NSUInteger frequency = node.frequency;
    ACDoubleLinkedList *oldLinkList = self.freqMap[@(node.frequency)];
    [oldLinkList removeNode:node];
    if ([oldLinkList isEmpty]) {
        //移除旧的的链表
        [self.freqMap removeObjectForKey:@(node.frequency)];
    }
    if (self.minFreq == frequency && ([oldLinkList isEmpty] || oldLinkList == nil)) {
        self.minFreq++;
    }
    frequency ++;
    node.frequency ++;
    ACDoubleLinkedList *newLinkList = self.freqMap[@(node.frequency)];
    if (newLinkList == nil) {
        newLinkList = [[ACDoubleLinkedList alloc] init];
        [self.freqMap setObject:newLinkList forKey:@(frequency)];
    }
    [newLinkList insertNodeAtHead:node];
}

- (void)eliminate {
    if (_count < _countLimit) {
        return;
    }
    ACDoubleLinkedList *linkList = self.freqMap[@(self.minFreq)];
    //淘汰头部节点（前面是按头部加的，最后访问的相同频次的在头部,淘汰频次相同 访问最早的数据）
    ACLinkedNode *node = linkList.tail;
    [linkList removeNode:node];
    NSLog(@" 被淘汰的数据 key:%@ value:%@ 使用频率%zd",node.key,node.value,node.frequency);
    if ([linkList isEmpty]) {
        //移除频次对应的 双向链表
        [self.freqMap removeObjectForKey:@(self.minFreq)];
    }
    [self.map removeObjectForKey:node.key];
    _count --;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
