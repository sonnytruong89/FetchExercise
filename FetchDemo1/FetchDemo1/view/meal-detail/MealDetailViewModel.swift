//
//  MealDetailViewModel.swift
//  FetchDemo1
//
//  Created by Sonny Truong on 8/15/24.
//

import Combine
import UIKit

class MealDetailViewModel: ObservableObject {
    @Published var mealDetail: MealDetail?
    @Published var isLoading = false
    
    private let mealService = MealService()

    private var cancellables = Set<AnyCancellable>()
    
    @MainActor
    func fetchMealDetail(id: String) async {
        isLoading = true
        self.mealDetail = try? await mealService.fetchMealDetail(id: id)
        isLoading = false
    }
}
