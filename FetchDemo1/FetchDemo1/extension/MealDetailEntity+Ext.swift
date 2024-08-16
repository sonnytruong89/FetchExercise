//
//  MealDetailEntity+Ext.swift
//  FetchDemo1
//
//  Created by Sonny Truong on 8/15/24.
//

import Foundation

extension MealDetailEntity {
    func update(from mealDetail: MealDetail) {
        self.idMeal = mealDetail.idMeal
        self.strMeal = mealDetail.strMeal
        self.strInstructions = mealDetail.strInstructions
        self.strMealThumb = mealDetail.strMealThumb
        
        self.strDrinkAlternate = mealDetail.strDrinkAlternate
        self.strCategory = mealDetail.strCategory
        self.strArea = mealDetail.strArea
        self.strTags = mealDetail.strTags
        self.strYoutube = mealDetail.strYoutube
        self.strSource = mealDetail.strSource
        self.strImageSource = mealDetail.strImageSource
        self.strCreativeCommonsConfirmed = mealDetail.strCreativeCommonsConfirmed
        self.dateModified = mealDetail.dateModified
        
        if let ingredientDict = mealDetail.strIngredient, let ingredientData = try? JSONSerialization.data(withJSONObject: ingredientDict) {
            self.strIngredient = ingredientData
        }
        
        if let measureDict = mealDetail.strMeasure , let measureData = try? JSONSerialization.data(withJSONObject: measureDict) {
            self.strMeasure = measureData
        }
    }
}
