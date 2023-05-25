//
//  EnvironmentKeys.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 5/25/23.
//

import SwiftUI

struct IsLoadingKey: EnvironmentKey {
    static var defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    public var isLoading: Binding<Bool> {
        get { self[IsLoadingKey.self] }
        set { self[IsLoadingKey.self] = newValue }
    }
}
