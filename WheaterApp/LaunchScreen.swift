//
//  LaunchScreen.swift
//  WheaterApp
//
//  Created by Abraao Nascimento on 27/09/2023.
//

import SwiftUI
import LoadingPacmanView

struct LaunchScreen: View {
    var body: some View {
        LoadingView()
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LaunchScreen()
        }
        
    }
}
