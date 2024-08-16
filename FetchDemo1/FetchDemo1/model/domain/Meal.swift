//
//  Meal.swift
//  FetchDemo1
//
//  Created by Sonny Truong on 8/15/24.
//

import Foundation

struct Meal: Identifiable, Codable {
    var id : String {idMeal}
    
    let idMeal: String
    let strMeal: String
    let strMealThumb: String?
}

//MARK: Mapping
extension Meal {
    init(from mealDB: MealEntity) {
        self.idMeal = mealDB.idMeal!
        self.strMeal = mealDB.strMeal!
        self.strMealThumb = mealDB.strMealThumb
    }
}
