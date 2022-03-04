//
//  ContentView.swift
//  Shared
//
//  Created by Borna Libertines on 01/03/22.
//

import SwiftUI


struct ContentView: View {
   @ObservedObject private var gifs = ViewModel()
   @State private var selectedIndex = 0
   var body: some View {
      NavigationView{
         GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0, content: {
               // MARK: Inserstion Sort
               HStack(alignment: .center, spacing: 8, content: {
                  /*HStack(){
                   Button(action: {self.gifs.sortArrayA()}) {
                   HStack {Text("ascending")}.padding(10.0)
                   .overlay(RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 2.0))
                   }.padding(.leading)
                   }
                   
                   Spacer()
                   HStack(){
                   Button(action: {self.gifs.linearS(k: 2)}) {
                   HStack {Text("Love")}.padding(10.0)
                   .overlay(RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 2.0)).foregroundColor(Color.cyan)
                   }.padding(.trailing,10)
                   }*/
               })
               // MARK: Search Gifs
               Section(header: VStack(alignment: .leading, spacing: 8){
                  Text("Gifs Search").font(.body).foregroundColor(.purple).fontWeight(.bold).padding(.leading)
               }, content: {
                  List{
                     ForEach(self.gifs.searchgif, id: \.id) { gif in
                        GifCell(gif: gif, geometry: geometry)
                        
                     }
                  }.listStyle(.plain)
               })
               // MARK: Gifs
               Section(header: VStack(alignment: .leading, spacing: 8){
                  Text("Gifs Trading").font(.body).foregroundColor(.purple).fontWeight(.bold).padding(.leading)
               }, content: {
                  List{
                     ForEach(self.gifs.gifs, id: \.id) { gif in
                        GifCell(gif: gif, geometry: geometry)
                           .onTapGesture {
                              Task(priority: .userInitiated, operation: {
                                // do {
                                    await self.gifs.linearS(k: gif)
                                // } catch {
                                    //print(error)
                                 //}
                              })
                              
                           }
                     }
                  }.listStyle(.plain)
               })
            })
               .task{
                  await gifs.loadGift()
               }
               .refreshable {
                  await gifs.loadGift()
               }
         }//gio
         .hideNavigationBar()
      }//nav
      .edgesIgnoringSafeArea(.all)
      .navigationViewStyle(StackNavigationViewStyle())
   }
}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      ContentView()
   }
}

extension View {
   func hideNavigationBar() -> some View {
      modifier(HideNavigationBarModifier())
   }
}
struct HideNavigationBarModifier: ViewModifier {
   func body(content: Content) -> some View {
      content
         .navigationBarBackButtonHidden(true)
         .navigationBarHidden(true)
         .navigationBarTitle("")
   }
}

