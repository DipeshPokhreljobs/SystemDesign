//
//  PriorityQueue.swift
//  PriorityQueue
//
//  Created by Dipesh Pokhrel on 30/12/22.
//

import Foundation

protocol PriorityQueue {
    associatedtype T
    mutating func insert(element : T)
    mutating func delete()->T?
}

protocol PriorityType : Hashable {
    var priority : Int {get set}
}

struct Queue <T : PriorityType> : PriorityQueue {
    var holder : [T]?

    mutating func insert(element: T) {
        if var _ = holder {
            holder!.append(element)
            hepify(index: holder!.count - 1)
        }else {
            holder = [element]
        }
    }
    
    mutating func hepify(index : Int){
        let index = index
        let parent = ((index - 1)/2)
        if index < holder!.count && parent < holder!.count {
            if let parentValue = holder?[parent] as? T {
                if let originalValue  = holder?[index] as? T {
                    if originalValue.priority > parentValue.priority {
                        holder?.swapAt(index, parent)
                        hepify(index: parent)
                    }
                }
            }
        }
    }
    
    mutating func heapifyAfterDeletion(index : Int) {
        let leftChildIndex = index * 2 + 1
        let rightChildIndez = index * 2 + 2
        if leftChildIndex < holder!.count &&  rightChildIndez < holder!.count {
            let leftChild = holder?[leftChildIndex]
            let rightChild = holder?[rightChildIndez]
            let orignal = holder?[index]
            
            var maximum = orignal
            var maxiumIndex = index
            
            if leftChild?.priority ?? 0 > maximum?.priority ?? 0 {
                maxiumIndex = leftChildIndex
                maximum = leftChild
            }
            if rightChild?.priority ?? 0 > maximum?.priority ?? 0 {
                maxiumIndex = rightChildIndez
                maximum = rightChild
            }
            if index != maxiumIndex {
                holder?.swapAt(maxiumIndex, index)
                heapifyAfterDeletion(index: maxiumIndex)
            }
        }
    }
    
    mutating func delete() -> T? {
        var deletedItem : T?
        if holder!.count > 0 {
            deletedItem = holder?[0]
            holder![0] = holder![holder!.count - 1]
            holder = holder?.dropLast(1)
            heapifyAfterDeletion(index: 0)
            return deletedItem
        }
        return nil
    }
}

