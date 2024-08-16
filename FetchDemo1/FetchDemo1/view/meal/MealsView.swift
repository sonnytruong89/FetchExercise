//
//  MealsView.swift
//  FetchDemo1
//
//  Created by Sonny Truong on 8/15/24.
//

import SwiftUI
import CoreData

struct MealsView: View {
    @StateObject private var viewModel = MealsViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List(viewModel.meals) { meal in
                        NavigationLink(destination: MealDetailView(mealID: meal.idMeal)) {
                            Text(meal.strMeal)
                        }
                    }
                    
                    Button("Refresh") {
                        Task {
                            await viewModel.fetchDesserts()
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Desserts")
            .onAppear {
                Task {
                    // Only fetch if the list is empty
                    if viewModel.meals.isEmpty {
                        await viewModel.fetchDesserts()
                    }
                }
                
            }
        }
    }
}
#Preview {
    MealsView()
}
