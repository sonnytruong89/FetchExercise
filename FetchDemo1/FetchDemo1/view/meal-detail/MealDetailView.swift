//
//  MealDetailView.swift
//  FetchDemo1
//
//  Created by Sonny Truong on 8/15/24.
//

import Foundation
import SwiftUI

struct MealDetailView: View {
    let mealID: String
    @StateObject private var viewModel = MealDetailViewModel()
    
    var body: some View {
        GeometryReader(content: { geo in
            ScrollView {
                if let mealDetail = viewModel.mealDetail {
                    VStack(alignment: .leading) {
                        Text(mealDetail.strMeal)
                            .font(.title)
                            .padding(.bottom)
                        
                        //Apply Cache
                        if let urlString = mealDetail.strMealThumb, let url = URL(string: urlString) {
                            
                            if let image = ImageCache.shared.getImage(forKey: urlString) {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: geo.size.width, height: geo.size.width)
                            } else {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                        .onAppear(perform: {
                                            let renderer = ImageRenderer(content: image)
                                            if let uiImage = renderer.uiImage {
                                                ImageCache.shared.setImage(uiImage, forKey: urlString)
                                            }
                                        })
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: geo.size.width, height: geo.size.width)
                            }
                        }
                        
                        Text("Instructions")
                            .font(.headline)
                            .padding(.vertical)
                        
                        Text(mealDetail.strInstructions ?? "")
                        
                        Text("Ingredients")
                            .font(.headline)
                            .padding(.vertical)
                        
                        ForEach(1...20, id: \.self) { index in
                            if let ingredient = mealDetail.strIngredient?["strIngredient\(index)"],
                               let measure = mealDetail.strMeasure?["strMeasure\(index)"],
                               !ingredient.isEmpty {
                                Text("\(ingredient): \(measure)")
                            }
                        }
                    }
                } else {
                    ProgressView()
                        .onAppear {
                            Task {
                                await viewModel.fetchMealDetail(id: mealID)
                            }
                        }
                }
            }
        })
        .navigationTitle("Meal Detail")
    }
}

#Preview {
    MealDetailView(mealID: "")
}
