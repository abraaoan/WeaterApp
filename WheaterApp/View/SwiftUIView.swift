//
//  SwiftUIView.swift
//  WheaterApp
//
//  Created by Abraao Nascimento on 05/10/2023.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
//        VStack(alignment: .leading) {
//            Text("16:00")
//                .font(.system(size: 12))
//                .foregroundColor(Color("textColor"))
//                .padding(.bottom, 0)
//            Image(uiImage: UIImage(named: "placeholder")!)
//                .frame(width: 50, height: 50)
//                .padding(.bottom, -15)
//                .padding(.top, -15)
//                .padding(.leading, 25)
//            Text("22º")
//                .font(.system(size: 24))
//                .foregroundColor(Color("textColor"))
//                .padding(.top, 0)
//        }
//        .padding(10)
//        .background(
//            BgCardShape()
//                .fill(LinearGradient(colors: [Color("cardDark"),
//                                              Color("cardLight")],
//                                     startPoint: .bottomLeading,
//                                     endPoint: .topTrailing)))
        
        VStack(alignment: .leading) {
            List {
                Section(header: Text("TEST!")) {
                    
                    ScrollView(.horizontal) {
                        HStack {
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                        }
                        .ignoresSafeArea(.all)
                    }
                    .padding(0)
                    .frame(minWidth: 100, maxWidth: .infinity)
                    .scrollIndicators(SwiftUI.ScrollIndicatorVisibility.hidden)
                    .listRowInsets(EdgeInsets())
                    
                    ScrollView(.horizontal) {
                        HStack {
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                        }
                        .ignoresSafeArea(.all)
                    }
                    .padding(0)
                    .frame(minWidth: 100, maxWidth: .infinity)
                    .scrollIndicators(SwiftUI.ScrollIndicatorVisibility.hidden)
                    .listRowInsets(EdgeInsets())
                    
                    
                }
                
                Section(header: Text("TEST 2!")) {
                    
                    ScrollView(.horizontal) {
                        HStack {
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                        }
                        .ignoresSafeArea(.all)
                    }
                    .padding(0)
                    .frame(minWidth: 100, maxWidth: .infinity)
                    .scrollIndicators(SwiftUI.ScrollIndicatorVisibility.hidden)
                    
                    ScrollView(.horizontal) {
                        HStack {
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                            Text("TEst")
                        }
                        .ignoresSafeArea(.all)
                    }
                    .padding(0)
                    .frame(minWidth: 100, maxWidth: .infinity)
                    .scrollIndicators(SwiftUI.ScrollIndicatorVisibility.hidden)
                    
                    
                }
            }
            .frame(minWidth: 100, maxWidth: .infinity)
            .listStyle(.inset)
            .padding(0)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
