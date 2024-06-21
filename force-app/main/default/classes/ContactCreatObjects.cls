public with sharing class ContactCreatObjects {
    public static void createContacts(Integer numberOfContacts){
        
        List<Contact> conL = new List<Contact>();
        for(Integer i=0; i<numberOfContacts; i++){
            Contact cc = new Contact();
            cc.FirstName = 'TesteContact' + i;
            cc.LastName = 'LastName' + i;
            cc.Email = 'email' + i + '@example.com';
            cc.Department = 'Finance';
            conL.add(cc);
        }
     try{
        insert conL;
        System.debug('Successfully inserted ' + numberOfContacts + ' contacts.');
    } catch (DmlException e) {
        System.debug('Error inserting contacts: ' + e.getMessage());
    }
   
   }
}