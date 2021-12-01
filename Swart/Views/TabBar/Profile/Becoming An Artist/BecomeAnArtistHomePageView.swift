//
//  SwitchPageTabView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 02/10/2021.
//

import SwiftUI

struct BecomeAnArtistHomePageView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var resetToRootView = false
    
    var btnBack : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "clear")
                .foregroundColor(.white)
                .opacity(0.7)
            })
        }
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .center, spacing: 5) {
                    Image("Artist")
                        .resizable()
                        .scaledToFit()
                    
                    Spacer()
                
                    VStack(alignment: .leading, spacing: 25) {
                        
                        Text("Become an Artist in 10 easy steps")
                            .fontWeight(.semibold)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        
                        Text("You are about to join the Swart artists community. \nWhether you are professionals or amateurs, Swart is a showcase for your artistic talents. \nMore visibility towards the general public and your peers, the creation of personalized works, teaching, a gain of experience and above all, multiple encounters, this is all that you can expect in using Swart.")
                            .fontWeight(.semibold)
                            .font(.system(size: 13))
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                
                    NavigationLink(destination: WhichArtView(resetToRootView: $resetToRootView), isActive: self.$resetToRootView) {
                                        
                            Text("Let's go!").bold()
                                .frame(width: UIScreen.main.bounds.size.width * 3/4, height: 15, alignment: .center)
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(.mainRed))
                        
                        }.isDetailLink(false)
                    
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
        }
    }
}

struct SwitchPageTabView_Previews: PreviewProvider {
    static var previews: some View {
        BecomeAnArtistHomePageView()
    }
}
