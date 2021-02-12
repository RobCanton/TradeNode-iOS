//
//  Node.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-02-10.
//

import Foundation


enum BinaryTree<T> {
    case empty
    indirect case node(BinaryTree, T, BinaryTree)
}
