//
//  FruitModel.swift
//  CloudKitTest
//
//  Created by Guilherme Nunes Lobo on 06/11/23.
//

import SwiftUI
import CloudKit

struct FruitModel: Hashable {
    let name: String
    let record: CKRecord
}
