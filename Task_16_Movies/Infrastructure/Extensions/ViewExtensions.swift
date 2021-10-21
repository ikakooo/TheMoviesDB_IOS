//
//  ViewExtensions.swift
//  Task_16_Movies
//
//  Created by MacBook Pro on 21.10.21.
//

import Foundation
import UIKit

extension UIButton {
    public func setAllStatesTitle(_ newTitle: String){
        self.setTitle(newTitle, for: .normal)
        self.setTitle(newTitle, for: .selected)
        self.setTitle(newTitle, for: .disabled)
    }
}
