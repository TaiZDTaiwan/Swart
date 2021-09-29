//
//  OnboardingContainerView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 22/09/2021.
//

import SwiftUI

struct OnboardingContainerView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    var body: some View {
        
        Button(action: {
            isOnboarding = false
        }, label: {
            /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
        })
    }
}

struct OnboardingContainerView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingContainerView()
    }
}
