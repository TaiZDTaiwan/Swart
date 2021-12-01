//
//  RefactoringViews.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 22/10/2021.
//

import SwiftUI

struct ButtonsForArtistForm: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var isAlertDismissPresented: Bool
    @Binding var resetToRootView: Bool
    
    var body: some View {
        HStack {
            BackButtonForArtistForm(presentationMode: _presentationMode)
            
            Spacer()
            
            DismissButtonForArtistForm(isAlertDismissPresented: $isAlertDismissPresented, resetToRootView: $resetToRootView)
            
        }.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
    }
}

struct BackButtonForArtistForm: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack(spacing: -12) {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.white)
                    .opacity(0.7)
                    .padding()
                
                Text("Back")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
            }
        })
    }
}

struct DismissButtonForArtistForm: View {
    
    @Binding var isAlertDismissPresented: Bool
    @Binding var resetToRootView: Bool
    
    var body: some View {
        Button(action: {
            isAlertDismissPresented = true
        }, label: {
            Image(systemName: "clear")
                .foregroundColor(.white)
                .opacity(0.8)
                .padding()
        })
        .alert(isPresented: $isAlertDismissPresented) {
            Alert(
                title: Text("You are about to undo current artist form."),
                message: .none,
                primaryButton: .destructive(Text("Confirm")) {
                    resetToRootView = false
                },
                secondaryButton: .cancel()
            )
        }
    }
}

struct TextLabelNextForArtistForm: View {
    var body: some View {
        Text("Next").bold()
            .frame(width: 42, height: 0, alignment: .center)
            .font(.system(size: 18))
            .foregroundColor(.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.mainRed).opacity(0.8))
    }
}

struct TextLabelIgnoreForArtistForm: View {
    var body: some View {
        Text("Ignore this step").bold().underline()
            .font(.system(size: 15))
            .foregroundColor(.black)
            .padding()
    }
}

struct BackgroundForArtistForm: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.7496727109, green: 0.1164080873, blue: 0.1838892698, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.7142756581, blue: 0.59502846, alpha: 1))]), startPoint: .topLeading, endPoint: .topTrailing)
            .ignoresSafeArea()
    }
}

struct NextButtonForArtistForm: View {
    var body: some View {
        Text("Next").bold()
            .frame(width: 42, height: 0, alignment: .center)
            .font(.system(size: 18))
            .foregroundColor(.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.mainRed).opacity(0.8))
    }
}

struct ReviewAndSaveButtonForArtistForm: View {
    
    var text: String
    
    var body: some View {
        Text(text).bold()
            .frame(width: 120, height: 5, alignment: .center)
            .font(.system(size: 18))
            .foregroundColor(.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.mainRed).opacity(0.8))
    }
}

struct TitleForArtistForm: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .fontWeight(.semibold)
            .font(.title)
            .foregroundColor(.white)
            .padding()
    }
}

struct CaptionForArtistForm: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .fontWeight(.semibold)
            .font(.caption)
            .foregroundColor(.white)
            .padding()
    }
}
