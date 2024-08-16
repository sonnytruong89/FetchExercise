//
//  MealEntity+Ext.swift
//  FetchDemo1
//
//  Created by Sonny Truong on 8/15/24.
//

import Foundation

extension MealEntity {
    func update(from meal: Meal) {
        self.idMeal = meal.idMeal
        self.strMeal = meal.strMeal
        self.strMealThumb = meal.strMealThumb
    }
}
