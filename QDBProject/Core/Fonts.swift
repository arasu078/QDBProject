//
//  Fonts.swift
//  QDBProject
//
//  Created by Murugesan, Ponnarasu (Cognizant) on 13/04/23.
//

import UIKit

enum Fonts: String
{
    case Regular = "Helvetica"
    case Bold = "Helvetica-Bold"
    func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}
