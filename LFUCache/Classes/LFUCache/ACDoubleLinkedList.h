//
//  ACDoubleLinkedList.h
//  Cache
//
//  Created by caixiang on 2021/8/14.
//

#import <Foundation/Foundation.h>

@class ACLinkedNode;

@interface ACDoubleLinkedList : NSObject
/// 头结点
@property (nonatomic, strong, readonly) ACLinkedNode *head;
/// 尾节点
@property (nonatomic, strong, readonly) ACLinkedNode *tail;
/// 大小
@property (nonatomic,readonly) NSUInteger count;

/// 插入一个新节点到链表头部
/// @param node 新节点
- (ACLinkedNode *)insertNodeAtHead:(ACLinkedNode *)node;

/// 插入一个新节点到链表尾部
/// @param node 新节点
- (ACLinkedNode *)insertNodeAtTail:(ACLinkedNode *)node;

/// 插入一个新节点到链表指定位置（传nil 代表插入到队尾）
/// @param node 需要插入的节点
/// @param position 要插入的位置节点
- (ACLinkedNode *)insertNode:(ACLinkedNode *)node before:(ACLinkedNode *)position;

/// 将已存在的节点移动到头部
/// @param node 要被移动的节点
- (ACLinkedNode *)bringNodeToHead:(ACLinkedNode *)node;
/// 移除节点
/// @param node 被移除的节点
- (void)removeNode:(ACLinkedNode *)node;

/// 移除所有
- (void)removeAll;

/// 是否为空
- (BOOL)isEmpty;

@end
