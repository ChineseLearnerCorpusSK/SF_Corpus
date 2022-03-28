/**
 * @description 
 *
 * @author      bramclaeys
 * @date        31-05-2018
 */

public without sharing class ProductTriggerHandler extends TriggerHandler {

    @TestVisible
    private static Integer loopCount = 0;

    protected override void beforeInsert()  {
        TriggerHandler.bypass('ProductTriggerHandler');
        loopCount += 1;
        if(loopCount > 1) return;
        checkForDuplicateProducts(Trigger.new, null);
        TriggerHandler.clearBypass('ProductTriggerHandler');
    }

    protected override void beforeUpdate()  {
        TriggerHandler.bypass('ProductTriggerHandler');
        loopCount += 1;
        if(loopCount > 1) return;
        checkForDuplicateProducts(Trigger.new, (Map<Id, C4C_Product__c>) Trigger.oldMap);
        TriggerHandler.clearBypass('ProductTriggerHandler');
    }
    
    private static void checkForDuplicateProducts(List<C4C_Product__c> newProducts, Map<Id, C4C_Product__c> oldProducts) {
        Set<String> productNamesPrefixed = new Set<String>();
        
        for(C4C_Product__c newProduct : newProducts) {
            productNamesPrefixed.add(newProduct.Product_Name_Prefixed__c);
        }
        
        Map<String, C4C_Product__c> existingProducts = new Map<String, C4C_Product__c>();
        for(C4C_Product__c existingProduct : [SELECT Id, Product_Name_Prefixed__c FROM C4C_Product__c WHERE Product_Name_Prefixed__c IN :productNamesPrefixed]) {
            existingProducts.put(existingProduct.Product_Name_Prefixed__c, existingProduct);
        }
        
        if(existingProducts.size() > 0) {
            for(C4C_Product__c newProduct : newProducts) {
                
                if(Trigger.isUpdate) {
                    // Check if the Name or Vendor is changed
                    C4C_Product__c oldProduct = oldProducts.get(newProduct.Id);
                    if((oldProduct.Vendor__c != newProduct.Vendor__c || oldProduct.Name != newProduct.Name) 
                        && existingProducts.containsKey(newProduct.Product_Name_Prefixed__c) && newProduct.Id != existingProducts.get(newProduct.Product_Name_Prefixed__c).Id) {
                        newProduct.addError(Constants.VALIDATION_MESSAGE_DUPLICATE_PRODUCT);
                    }
                }
                
                if(Trigger.isInsert) {
                    if(existingProducts.containsKey(newProduct.Product_Name_Prefixed__c)) {
                        newProduct.addError(Constants.VALIDATION_MESSAGE_DUPLICATE_PRODUCT);
                    }
                }
            }
        }
    }
}