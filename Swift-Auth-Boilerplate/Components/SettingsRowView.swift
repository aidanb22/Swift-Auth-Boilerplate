//
//  SettingsRowView.swift
//  Swift-Auth-Boilerplate
//
//  Created by Aidan Blancas on 8/9/24.
//

import SwiftUI

struct SettingsRowView: View {
    
    let imageName: String
    let title: String
    let tintColor: Color
    
    
    var body: some View {
        HStack(spacing:12){
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundStyle(tintColor)
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.black)
            
        }
    }
}

#Preview {
    SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
}
