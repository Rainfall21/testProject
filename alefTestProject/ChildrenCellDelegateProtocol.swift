//
//  DeleteButtonDelegateProtocol.swift
//  alefTestProject
//
//  Created by Alibek Ismagulov on 31.07.2023.
//

import Foundation
import UIKit

protocol ChildrenViewCellDelegate : AnyObject {
    func deletePressed(cell: UITableViewCell)
    func finishEditCell(cell: UITableViewCell, kidName: String?, kidAge: String?)
}

