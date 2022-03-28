public class CorpusWrapper {

	@AuraEnabled
	public Corpus__c corpus = new Corpus__c();

	@AuraEnabled
	public List<PicklistService.PicklistItem> gender = PicklistService.getPicklist('Corpus__c', 'Gender__c');

	@AuraEnabled
	public List<PicklistService.PicklistItem> degree = PicklistService.getPicklist('Corpus__c', 'Degree__c');

	@AuraEnabled
	public List<PicklistService.PicklistItem> studyExchange = PicklistService.getPicklist('Corpus__c', 'Study_Exchange__c');

	@AuraEnabled
	public List<PicklistService.PicklistItem> proficiency = PicklistService.getPicklist('Corpus__c', 'Proficiency__c');

	@AuraEnabled
	public List<PicklistService.PicklistItem> hsk = PicklistService.getPicklist('Corpus__c', 'HSK__c');

	@AuraEnabled
	public List<PicklistService.PicklistItem> bilingual = PicklistService.getPicklist('Corpus__c', 'Bilingual__c');

	@AuraEnabled
	public List<PicklistService.PicklistItem> chineseHeritage = PicklistService.getPicklist('Corpus__c', 'Chinese_Heritage__c');

	@AuraEnabled
	public List<PicklistService.PicklistItem> translation = PicklistService.getPicklist('Corpus__c', 'Translation__c');

}