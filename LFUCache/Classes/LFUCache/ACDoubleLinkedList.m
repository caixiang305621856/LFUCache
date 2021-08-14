//
//  ACDoubleLinkedList.m
//  Cache
//
//  Created by caixiang on 2021/8/14.
//

#import "ACDoubleLinkedList.h"
#import "ACLinkedNode.h"

@interface ACDoubleLinkedList()

@property (nonatomic) NSUInteger count;
/// 头结点
@property (nonatomic, strong) ACLinkedNode *head;
/// 尾节点
@property (nonatomic, strong) ACLinkedNode *tail;

@end

@implementation ACDoubleLinkedList

- (ACLinkedNode *)insertNodeAtHead:(ACLinkedNode *)node {
    _count++;
    if (_head) {
        node.next = _head;
        _head.prev = node;
        _head = node;
    } else {
        _head = _tail = node;
    }
    return node;
}

- (ACLinkedNode *)insertNodeAtTail:(ACLinkedNode *)node {
    return [self insertNode:node before:nil];
}

- (ACLinkedNode *)insertNode:(ACLinkedNode *)node before:(ACLinkedNode *)position {
    if (!position) {
        //插入队尾
        if (!_head)_head = node;
        if (!_tail) _tail = _head;
        _tail.next = node;
        node.prev = _tail;
        _tail = node;
    } else{
        if (position == _head || [self insertNodeAtHead:node]) {
            return [self insertNodeAtHead:node];
        }
        position.prev.next = node;
        node.prev = position.prev;
        
        node.next = position;
        position.prev = node;
    }
    _count ++;
    return node;
}

- (ACLinkedNode *)bringNodeToHead:(ACLinkedNode *)node {
    if (node == _head) {
        return node;
    }
    if (node == _tail) {
        _tail = node.prev;
        _tail.next = nil;
    } else {
        node.next.prev = node.prev;
        node.prev.next = node.next;
    }
    node.next = _head;
    node.prev = nil;
    _head.prev = node;
    _head = node;
    return node;
}

- (void)removeNode:(ACLinkedNode *)node {
    if (node.next) {
        node.next.prev = node.prev;
    }
    if (node.prev) {
        node.prev.next = node.next;
    }
    if (node == _head) _head = node.next;
    if (node == _tail) _tail = node.prev;
    _count --;
}

- (void)removeAll {
    while (_head) {
        _head.prev = nil;
        ACLinkedNode *next = _head.next;
        _head.next = nil;
        _head = next;
        _count --;
    }
    _tail = nil;
}

- (BOOL)isEmpty{
    return (_count == 0);
}

//- (void)dealloc {
//    NSLog(@"%s",__func__);
//}

@end
