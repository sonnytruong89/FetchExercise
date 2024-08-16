//
//  MealService.swift
//  FetchDemo1
//
//  Created by Sonny Truong on 8/15/24.
//

import Foundation
import CoreData

class MealService {
    private let mealDB: MealDatabase
    private let apiProvider: APIProvider

    init(mealDatabase: MealDatabase = .shared, apiProvider: APIProvider = APIAsyncProvider()) {
        self.mealDB = mealDatabase
        self.apiProvider = apiProvider
    }

    func fetchDesserts() async throws -> [Meal] {
        if NetworkMonitor.shared.isConnected {
            let desserts = try await fetchDessertsFromServer()
            await saveMealsToCoreData(desserts.meals)
            return desserts.meals
        } else {
            return try await fetchDessertsFromCoreData()
        }
    }
    
    func fetchMealDetail(id: String) async throws -> MealDetail {
        if NetworkMonitor.shared.isConnected {
            let mealDetailResponse = try await fetchMealDetailFromServer(id: id)
            guard let mealDetail = mealDetailResponse.meals.first else {
                throw NSError(domain: "MealService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Meal detail not found"])
            }
            await saveMealDetailToCoreData(mealDetail)
            return mealDetail
        } else {
            return try await fetchMealDetailFromCoreData(id: id)
        }
    }

    //MARK: - Online Fetching
    private func fetchDessertsFromServer() async throws -> MealResponse {
        let api = FetchAPIs.GetDesserts()
        return try await apiProvider.request(for: api)
    }
    
    private func fetchMealDetailFromServer(id: String) async throws -> MealDetailResponse {
        let api = FetchAPIs.GetMealDetail(mealID: id)
        return try await apiProvider.request(for: api)
    }

}
//MARK: - Offline Fetching
extension MealService {
    private func fetchDessertsFromCoreData() async throws -> [Meal] {
        let context = mealDB.container.newBackgroundContext()
        return try await context.perform {
            let fetchRequest: NSFetchRequest<MealEntity> = MealEntity.fetchRequest()
            let cdMeals = try context.fetch(fetchRequest)
            return cdMeals.map { Meal(from: $0) }
        }
    }
    
    private func fetchMealDetailFromCoreData(id: String) async throws -> MealDetail {
        let context = mealDB.container.newBackgroundContext()
        return try await context.perform {
            let fetchRequest: NSFetchRequest<MealDetailEntity> = MealDetailEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "idMeal == %@", id)
            guard let cdMealDetail = try context.fetch(fetchRequest).first else {
                throw NSError(domain: "MealService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Meal detail not found in Core Data"])
            }
            return MealDetail(from: cdMealDetail)
        }
    }
}

//MARK: - Caching
extension MealService {
    private func saveMealsToCoreData(_ meals: [Meal]) async {
        let context = mealDB.container.newBackgroundContext()
        await context.perform {
            meals.forEach { meal in
                let fetchRequest: NSFetchRequest<MealEntity> = MealEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "idMeal == %@", meal.idMeal)
                if let existingMeal = try? context.fetch(fetchRequest).first {
                    existingMeal.update(from: meal)
                } else {
                    let mealDB = MealEntity(context: context)
                    mealDB.update(from: meal)
                }
            }
            self.mealDB.saveContext(context)
        }
    }
    
    private func saveMealDetailToCoreData(_ mealDetail: MealDetail) async {
        let context = mealDB.container.newBackgroundContext()
        await context.perform {
            let fetchRequest: NSFetchRequest<MealDetailEntity> = MealDetailEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "idMeal == %@", mealDetail.idMeal)
            if let existingMealDetail = try? context.fetch(fetchRequest).first {
                existingMealDetail.update(from: mealDetail)
            } else {
                let mealDetailDB = MealDetailEntity(context: context)
                mealDetailDB.update(from: mealDetail)
            }
            self.mealDB.saveContext(context)
        }
    }
}
