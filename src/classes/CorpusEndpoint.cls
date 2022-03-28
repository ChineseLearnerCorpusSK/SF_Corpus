public class CorpusEndpoint {

	@AuraEnabled
	public static CorpusWrapper getCorpusInformation() {
		CorpusWrapper preparedCorpus = new CorpusWrapper();
		System.debug('PR: ' + preparedCorpus);
		return preparedCorpus;
	}

	@AuraEnabled
	public static Corpus__c insertCorpusInformation(Corpus__c corpusForSave) {
		insert corpusForSave;

		return corpusForSave;
	}

	@AuraEnabled
	public static AnnotationWrapper getAnnotationInformation(String corpusId) {
		AnnotationWrapper preparedAnnotation = new AnnotationWrapper();

		preparedAnnotation.annotationsList = getAnnotations(corpusId);

		if (!preparedAnnotation.annotationsList.isEmpty()) {
			preparedAnnotation.annotatedText = preparedAnnotation.annotationsList[0].Corpus__r.Annotated_Text__c;
		}

		System.debug('AN: ' + preparedAnnotation);
		return preparedAnnotation;
	}

	@AuraEnabled
	public static List<Annotation__c> getAnnotations(String corpusId) {
		return [
				SELECT Id,
						Grammatical_Function__c,
						Has_Blank_Space__c,
						Incorrect_Selection_S__c,
						Incorrect_Selection_S_Tagset__c,
						Missing_M__c,
						Missing_M_Tagset__c,
						Other__c,
						Redundant_R__c,
						Redundant_R_Tagset__c,
						Selected_Character__c,
						Selected_Character_Index__c,
						Sentence_Structure__c,
						Tags__c,
						Word_Level__c,
						Word_Order_W__c,
						Word_Order_W_Tagset__c,
						Corpus__c,
						Corpus__r.Document_Id__c,
						Corpus__r.Corpus_Text__c,
						Corpus__r.Annotated_Text__c
				FROM Annotation__c
				WHERE Corpus__c = :corpusId
				ORDER BY Selected_Character_Index__c ASC
		];
	}

	@AuraEnabled
	public static String insertAnnotationInformation(Annotation__c annotationForSave) {
		String annotatedText = '';
		insert annotationForSave;
		List<Annotation__c> annotations = getAnnotations(annotationForSave.Corpus__c);

		if (!annotations.isEmpty()) {
			String originalText = annotations[0].Corpus__r.Corpus_Text__c;
			String tempString = '';
			Integer tempInt;
			for (Integer i = 0; i < annotations.size(); i++) {
				if (i == 0) {
					tempString = originalText.substring(0, Integer.valueOf(annotations[i].Selected_Character_Index__c));
				} else {
					tempString = originalText.substring(tempInt, Integer.valueOf(annotations[i].Selected_Character_Index__c));
				}

				tempInt = Integer.valueOf(annotations[i].Selected_Character_Index__c);

				if (annotations[i].Has_Blank_Space__c) {
					annotatedText = annotatedText + tempString + '  [';
				} else {
					annotatedText = annotatedText + tempString + '[';
				}

				if (annotations[i].Missing_M_Tagset__c != null) {
					annotatedText = annotatedText + annotations[i].Missing_M_Tagset__c;
				}

				if (annotations[i].Redundant_R_Tagset__c != null) {
					if (annotations[i].Missing_M_Tagset__c != null) {
						annotatedText = annotatedText + '; ';
					}
					annotatedText = annotatedText + annotations[i].Redundant_R_Tagset__c;
				}

				if (annotations[i].Word_Order_W_Tagset__c != null) {
					if (annotations[i].Missing_M_Tagset__c != null || annotations[i].Redundant_R_Tagset__c != null) {
						annotatedText = annotatedText + '; ';
					}
					annotatedText = annotatedText + annotations[i].Word_Order_W_Tagset__c;
				}

				if (annotations[i].Incorrect_Selection_S_Tagset__c != null) {
					if (annotations[i].Missing_M_Tagset__c != null
							|| annotations[i].Redundant_R_Tagset__c != null
							|| annotations[i].Word_Order_W_Tagset__c != null) {
						annotatedText = annotatedText + '; ';
					}
					annotatedText = annotatedText + annotations[i].Incorrect_Selection_S_Tagset__c;
				}

				annotatedText = annotatedText + ']';

				Integer lastIndex = i + 1;
				if (lastIndex == annotations.size()) {
					tempString = originalText.substring(tempInt);
					annotatedText = annotatedText + tempString;
				}
			}
		}

		update (new Corpus__c(Id = annotationForSave.Corpus__c, Annotated_Text__c = annotatedText));

		System.debug('ANNOTATED TEXT: ' + annotatedText);


		return annotatedText;
	}

}