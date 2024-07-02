@isTest
public with sharing class ContactCreatObjectsTest {
    @isTest
    public static void createContactsTest(){
        
        Integer numberOfContacts = 10;
        
        ContactCreatObjects.createContacts(numberOfContacts);
        
        List<Contact> conL = [SELECT FirstName, LastName, Email, Department FROM Contact WHERE FirstName LIKE 'TesteContact%'];
        // Verifique se o número correto de contas foi criado
        System.assertEquals(numberOfContacts, conL.size(), 'O número de contas criadas está incorreto.');
        
        for(Integer i=0; i<numberOfContacts; i++){
            Contact cc = conL[i];
            System.assertEquals('TesteContact' + i,cc.FirstName, 'O campo FirstName está incorreto' );
            System.assertEquals('LastName' + i, cc.LastName, 'O campo lastName está incorreto');
            System.assertEquals('email' + i + '@example.com',cc.Email, 'O campo Email está incorreto' );
            System.assertEquals('Finance',cc.Department, 'O campo Finance está incorreto' );
            
        }
    }
}