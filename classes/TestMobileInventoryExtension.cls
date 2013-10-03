@isTest 
private class TestMobileInventoryExtension{
    static testMethod void testMobileInventoryExtension() {
        // Create test data
        Merchandise__c m = new Merchandise__c(Name='Tester', Price__c=1.00, Quantity__c=10);
        insert m;
        
        // Make a page
        PageReference pageRef = Page.MobileInventory;
        Test.setCurrentPage(pageRef);
    
        // Create controller extensions
        ApexPages.StandardController sc = new ApexPages.standardController(m);
        MobileInventoryExtension e = new MobileInventoryExtension(sc);
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Name FROM Merchandise__c]));
        e = new MobileInventoryExtension(ssc);
                
        // Test positive case
        m.Quantity__c = 20;
        String result = MobileInventoryExtension.updateMerchandiseItem(m);
        System.assertEquals('Item Updated', result, 
                      'Unexpected response from MobileInventoryExtension.updateMerchandiseItem: ' + result);
        
        List<Merchandise__c> lm = [SELECT Id, Quantity__c from Merchandise__c WHERE Id =:
           m.Id LIMIT 1];
        System.assertEquals(20, lm[0].Quantity__c, 'Merchandise quantity was not updated');

        // Test negative case
        // Delete the merchandise and try to update it - should fail since it's not there any more!
        delete m;
        result = MobileInventoryExtension.updateMerchandiseItem(m);
        System.assertEquals('Update failed. First exception on row 0 with id '+m.Id+'; first error: ENTITY_IS_DELETED, entity is deleted: []', result, 
                      'Unexpected response from MobileInventoryExtension.updateMerchandiseItem: ' + result);
        
        // Test iOS user agent
        pageRef.getHeaders().put('User-Agent', 'Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3');
        System.assertEquals('cordova-2.3.0-ios.js', e.getCordovaLib());
        pageRef.getHeaders().put('User-Agent', 'Mozilla/5.0 (Linux; U; Android 2.2.1; en-us; Nexus One Build/FRG83) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1');
        System.assertEquals('cordova-2.3.0-android.js', e.getCordovaLib());
    }
}