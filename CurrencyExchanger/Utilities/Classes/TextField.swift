//
//  TextField.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/16/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit

public class TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
