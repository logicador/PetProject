//
//  App.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/09.
//

import UIKit


class App {
    
    // MARK: Property
    var userDefaults = UserDefaults.standard
    
    func isLogined() -> Bool {
        return self.userDefaults.bool(forKey: "isLogined")
    }
    
    func getUser() -> User {
        return User(id: userDefaults.integer(forKey: "uId"), type: userDefaults.string(forKey: "uType"), socialId: userDefaults.string(forKey: "uSocialId"), nickName: userDefaults.string(forKey: "uNickName"), email: userDefaults.string(forKey: "uEmail"), password: userDefaults.string(forKey: "uPassword"), peId: userDefaults.integer(forKey: "uPeId"), level: userDefaults.integer(forKey: "uLevel"), lastLoginedPlatform: userDefaults.string(forKey: "uLastLoginedPlatform"), isLogined: userDefaults.string(forKey: "uIsLogined"), status: userDefaults.string(forKey: "uStatus"), createdDate: userDefaults.string(forKey: "uCreatedDate"), updatedDate: userDefaults.string(forKey: "uUpdatedDate"), connectedDate: userDefaults.string(forKey: "uConnectedDate"), petCnt: userDefaults.integer(forKey: "uPetCnt"))
    }
    
    func login(user: User) {
        userDefaults.set(true, forKey: "isLogined")
        userDefaults.set(user.id, forKey: "uId")
        userDefaults.set(user.type, forKey: "uType")
        userDefaults.set(user.socialId, forKey: "uSocialId")
        userDefaults.set(user.nickName, forKey: "uNickName")
        userDefaults.set(user.email, forKey: "uEmail")
        userDefaults.set(user.password, forKey: "uPassword")
        userDefaults.set(user.peId, forKey: "peId")
        userDefaults.set(user.level, forKey: "uLevel")
        userDefaults.set(user.lastLoginedPlatform, forKey: "uLastLoginedPlatform")
        userDefaults.set(user.isLogined, forKey: "uIsLogined")
        userDefaults.set(user.status, forKey: "uStatus")
        userDefaults.set(user.createdDate, forKey: "uCreatedDate")
        userDefaults.set(user.updatedDate, forKey: "uUpdatedDate")
        userDefaults.set(user.connectedDate, forKey: "uConnectedDate")
        userDefaults.set(user.petCnt, forKey: "uPetCnt")
    }
    
    func logout() {
        userDefaults.set(false, forKey: "isLogined")
    }
    
    func getUserId() -> Int {
        return userDefaults.integer(forKey: "uId")
    }
    
//    func setUserPetId(peId: Int) {
//        userDefaults.set(peId, forKey: "uPeId")
//    }
    func getUserPetId() -> Int {
        return userDefaults.integer(forKey: "uPeId")
    }
    
    func getPet() -> Pet {
        let breed = Breed(id: userDefaults.integer(forKey: "peBId"), name: userDefaults.string(forKey: "peBName") ?? "", type: userDefaults.string(forKey: "peBType") ?? "")
        return Pet(id: userDefaults.integer(forKey: "peId"), uId: userDefaults.integer(forKey: "peUId"), bId: userDefaults.integer(forKey: "peBId"), name: userDefaults.string(forKey: "peName") ?? "", thumbnail: userDefaults.string(forKey: "peThumbnail") ?? "", birth: userDefaults.integer(forKey: "peBirth"), bcsStep: userDefaults.integer(forKey: "peBcsStep"), bcs: userDefaults.integer(forKey: "peBcs"), gender: userDefaults.string(forKey: "peGender") ?? "", neuter: userDefaults.string(forKey: "peNeuter") ?? "", inoculation: userDefaults.string(forKey: "peInoculation") ?? "", inoculationText: userDefaults.string(forKey: "peInoculationText") ?? "", serial: userDefaults.string(forKey: "peSerial") ?? "", serialNo: userDefaults.string(forKey: "peSerialNo") ?? "", weight: userDefaults.double(forKey: "peWeight"), createdDate: userDefaults.string(forKey: "peCreatedDate") ?? "", updatedDate: userDefaults.string(forKey: "peUpdatedDate") ?? "", breed: breed, monthAge: userDefaults.integer(forKey: "peMonthAge"))
    }
    
    func setPet(pet: Pet) {
        userDefaults.set(pet.id, forKey: "peId")
        userDefaults.set(pet.uId, forKey: "peUId")
        userDefaults.set(pet.bId, forKey: "peBId")
        userDefaults.set(pet.name, forKey: "peName")
        userDefaults.set(pet.thumbnail, forKey: "peThumbnail")
        userDefaults.set(pet.birth, forKey: "peBirth")
        userDefaults.set(pet.bcsStep, forKey: "peBcsStep")
        userDefaults.set(pet.bcs, forKey: "peBcs")
        userDefaults.set(pet.gender, forKey: "peGender")
        userDefaults.set(pet.neuter, forKey: "peNeuter")
        userDefaults.set(pet.inoculation, forKey: "peInoculation")
        userDefaults.set(pet.inoculationText, forKey: "peInoculationText")
        userDefaults.set(pet.serial, forKey: "peSerial")
        userDefaults.set(pet.serialNo, forKey: "peSerialNo")
        userDefaults.set(pet.weight, forKey: "peWeight")
        userDefaults.set(pet.createdDate, forKey: "peCreatedDate")
        userDefaults.set(pet.updatedDate, forKey: "peUpdatedDate")
        userDefaults.set(pet.breed.name, forKey: "peBName")
        userDefaults.set(pet.breed.type, forKey: "peBType")
        userDefaults.set(pet.monthAge, forKey: "peMonthAge")
    }
    
    func getPetName() -> String {
        return userDefaults.string(forKey: "peName") ?? ""
    }
    
//    func setPetId(peId: Int) {
//        userDefaults.set(peId, forKey: "peId")
//    }
    func getPetId() -> Int {
        return userDefaults.integer(forKey: "peId")
    }
    
    func setPetThumbnail(thumbnail: String) {
        userDefaults.set(thumbnail, forKey: "peThumbnail")
    }
    
    func setPetWarningFoodList(foodList: [Food]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(foodList) {
            userDefaults.set(encoded, forKey: "petWarningFoodList")
        }
    }
    func setPetWarningNutrientList(nutrientList: [Nutrient]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(nutrientList) {
            userDefaults.set(encoded, forKey: "petWarningNutrientList")
        }
    }
    func setPetGoodFoodList(foodList: [Food]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(foodList) {
            userDefaults.set(encoded, forKey: "petGoodFoodList")
        }
    }
    func setPetGoodNutrientList(nutrientList: [Nutrient]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(nutrientList) {
            userDefaults.set(encoded, forKey: "petGoodNutrientList")
        }
    }
    func setPetSimilarGoodFoodList(foodList: [Food]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(foodList) {
            userDefaults.set(encoded, forKey: "petSimilarGoodFoodList")
        }
    }
    func setPetSimilarGoodNutrientList(nutrientList: [Nutrient]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(nutrientList) {
            userDefaults.set(encoded, forKey: "petSimilarGoodNutrientList")
        }
    }
    
    func getPetWarningFoodList() -> [Food] {
        guard let obj = userDefaults.object(forKey: "petWarningFoodList") as? Data else { return [] }
        let decoder = JSONDecoder()
        guard let foodList = try? decoder.decode(Array<Food>.self, from: obj) else { return [] }
        return foodList
    }
    func getPetWarningNutrientList() -> [Nutrient] {
        guard let obj = userDefaults.object(forKey: "petWarningNutrientList") as? Data else { return [] }
        let decoder = JSONDecoder()
        guard let nutrientList = try? decoder.decode(Array<Nutrient>.self, from: obj) else { return [] }
        return nutrientList
    }
    func getPetGoodFoodList() -> [Food] {
        guard let obj = userDefaults.object(forKey: "petGoodFoodList") as? Data else { return [] }
        let decoder = JSONDecoder()
        guard let foodList = try? decoder.decode(Array<Food>.self, from: obj) else { return [] }
        return foodList
    }
    func getPetGoodNutrientList() -> [Nutrient] {
        guard let obj = userDefaults.object(forKey: "petGoodNutrientList") as? Data else { return [] }
        let decoder = JSONDecoder()
        guard let nutrientList = try? decoder.decode(Array<Nutrient>.self, from: obj) else { return [] }
        return nutrientList
    }
    func getPetSimilarGoodFoodList() -> [Food] {
        guard let obj = userDefaults.object(forKey: "petSimilarGoodFoodList") as? Data else { return [] }
        let decoder = JSONDecoder()
        guard let foodList = try? decoder.decode(Array<Food>.self, from: obj) else { return [] }
        return foodList
    }
    func getPetSimilarGoodNutrientList() -> [Nutrient] {
        guard let obj = userDefaults.object(forKey: "petSimilarGoodNutrientList") as? Data else { return [] }
        let decoder = JSONDecoder()
        guard let nutrientList = try? decoder.decode(Array<Nutrient>.self, from: obj) else { return [] }
        return nutrientList
    }
    
    func getSimilarCnt() -> Int {
        return userDefaults.integer(forKey: "petSimilarCnt")
    }
    func setSimilarCnt(cnt: Int) {
        userDefaults.set(cnt, forKey: "petSimilarCnt")
    }
    
    func getWeakDiseaseList() -> [Disease] {
        guard let obj = userDefaults.object(forKey: "petWeakDiseaseList") as? Data else { return [] }
        let decoder = JSONDecoder()
        guard let diseaseList = try? decoder.decode(Array<Disease>.self, from: obj) else { return [] }
        return diseaseList
    }
    func setWeakDiseaseList(diseaseList: [Disease]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(diseaseList) {
            userDefaults.set(encoded, forKey: "petWeakDiseaseList")
        }
    }
}
