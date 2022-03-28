public class AnnotationWrapper {

	@AuraEnabled
	public Annotation__c annotation = new Annotation__c();

	@AuraEnabled
	public List<Annotation__c> annotationsList = new List<Annotation__c>();

	@AuraEnabled
	public String annotatedText = '';

	@AuraEnabled
	public List<PicklistService.PicklistItem> wordLevel = PicklistService.getPicklist('Annotation__c', 'Word_Level__c');

	@AuraEnabled
	public List<PicklistService.PicklistItem> grammaticalFunction = PicklistService.getPicklist('Annotation__c', 'Grammatical_Function__c');

	@AuraEnabled
	public List<PicklistService.PicklistItem> sentenceStructure = PicklistService.getPicklist('Annotation__c', 'Sentence_Structure__c');

	@AuraEnabled
	public List<PicklistService.PicklistItem> otherValues = PicklistService.getPicklist('Annotation__c', 'Other__c');

}