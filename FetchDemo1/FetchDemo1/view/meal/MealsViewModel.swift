//
//  MealsViewModel.swift
//  FetchDemo1
//
//  Created by Sonny Truong on 8/15/24.
//

import Foundation
import Combine
import UIKit

class MealsViewModel : ObservableObject {
    
    @Published var meals: [Meal] = []
    @Published var isLoading = false
    
    private let mealService = MealService()

    @MainActor
    func fetchDesserts() async {
        guard !isLoading else { return }
        isLoading = true
        
        if let newMeals = try? await mealService.fetchDesserts() {
            meals = newMeals
        }
        isLoading = false
    }
}
