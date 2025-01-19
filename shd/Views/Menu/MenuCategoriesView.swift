//
//  MenuCategoriesView.swift
//  shd
//
//  Created by Тигран Дарчинян on 19.01.2025.
//

import SwiftUI
import Kingfisher

public struct MenuCategoriesView: View {
    let sortedCategories: [String]
    @Binding var selectedCategory: String?
    @ObservedObject var menuData: MenuData
    
    public var body: some View {
        ScrollViewReader { proxy in
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(sortedCategories, id: \.self) { category in
                            Button(action: {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    selectedCategory = category
                                    proxy.scrollTo(category, anchor: .top)
                                }
                            }) {
                                VStack() {
                                    Spacer()
                                    Text(category)
                                        .frame(maxWidth: .infinity)
                                        .font(.caption2.bold())
                                        .foregroundColor(selectedCategory == category ? Color("DarkModeText") : Color("DarkModeIcon"))
                                        .offset(y: 20)
                                    Spacer()
                                }
                                .frame(width: 80, height: 100)
                                .background(selectedCategory == category ? .thickMaterial : .ultraThinMaterial)
                                .cornerRadius(20)
                                .overlay(alignment: .top) {
                                    if let firstItem = menuData.menuCategories[category]?.first, let imageUrl = firstItem.image, let url = URL(string: imageUrl) {
                                        KFImage(url)
                                            .placeholder {
                                                ProgressView()
                                                    .frame(width: 70, height: 70)
                                                    .background(Color("DarkModeElBg"))
                                                    .clipShape(Circle())
                                            }
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 70, height: 70)
                                            .clipShape(Circle())
                                            .padding()
                                            .offset(y: -50)
                                            .shadow(
                                                color: selectedCategory == category ? Color("DarkModeShadow") : .clear,
                                                radius: selectedCategory == category ? 10 : 0,
                                                x: 0,
                                                y: selectedCategory == category ? 12 : 0
                                            )
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .padding(.top, 30)
                }
            }
            
        }
    }
}
