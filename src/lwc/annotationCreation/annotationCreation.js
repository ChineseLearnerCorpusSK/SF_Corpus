import { LightningElement, api, track } from 'lwc';
import getAnnotationInformation from '@salesforce/apex/CorpusEndpoint.getAnnotationInformation';
import getAnnotations from '@salesforce/apex/CorpusEndpoint.getAnnotations';
import insertAnnotationInformation from '@salesforce/apex/CorpusEndpoint.insertAnnotationInformation';

export default class AnnotationCreation extends LightningElement {

    /* VARIABLES */

    //record
    @api corpus;

    @track annotation;
    @track annotations = [];
    @track annotatedText;

    //picklists
    @track wordLevelOptions = [];
    @track grammaticalFunctionOptions = [];
    @track sentenceStructureOptions = [];
    @track otherValuesOptions = [];
    @track wordLevelSecondOptions = [];
    @track grammaticalFunctionSecondOptions = [];
    @track sentenceStructureSecondOptions = [];
    @track otherValuesSecondOptions = [];

    //handlers
    @track loading = true;
    @track showFirstMultipicklist = false;
    @track showSecondMultipicklist = false;

    //javascript only
    _annotationCharacter = '';
    _apexResponse;
    _wordLevel = [];
    _grammaticalFunction = [];
    _sentenceStructure = [];
    _other = [];

    /* INIT */
    connectedCallback() {
        this.fetchTagSet();
    }

    /* ENDPOINTS */
    fetchTagSet() {
        this.loading = true;
        getAnnotationInformation({corpusId : this.corpus.Id}).then(result => {
            this._apexResponse = result;
            console.log('RESULT: ' +JSON.stringify(result));
            this.annotation = this._apexResponse.annotation;
            this.annotations = this._apexResponse.annotationsList;
            console.log('LIST: ' +JSON.stringify(this.annotations));

            this.showFirstMultipicklist = true;
            this.showSecondMultipicklist = false;

            this.annotation.Missing_M_Tagset__c = '';
            this.annotation.Redundant_R_Tagset__c = '';
            this.annotation.Word_Order_W_Tagset__c = '';
            this.annotation.Incorrect_Selection_S_Tagset__c = '';

            this.wordLevelOptions = this._apexResponse.wordLevel;
            this.grammaticalFunctionOptions = this._apexResponse.grammaticalFunction;
            this.sentenceStructureOptions = this._apexResponse.sentenceStructure;
            this.otherValuesOptions = this._apexResponse.otherValues;

            this.loading = false;
        }).catch(error => {
            console.log('Error fetch data: ' +this.parseErrorMessage(error));
            this.loading = false;
        });
    }

    getExistingAnnotation() {
        this.loading = true;
        getAnnotations({corpusId : this.corpus.Id}).then(result => {
            this.annotations = result;
            this.loading = false;
        }).catch(error => {
            console.log('Error get existing annotations: ' +this.parseErrorMessage(error));
            this.loading = false;
        });
    }

    saveAnnotation() {
        this.loading = true;
        console.log('ID: ' +this.corpus.Id);
        this.annotation.Corpus__c = this.corpus.Id;
        insertAnnotationInformation({annotationForSave : this.annotation}).then(result => {
            this.annotatedText = result;
            this.clearValues();
            this.getExistingAnnotation();
            this.loading = false;
        }).catch(error => {
            console.log('Error save annotation: ' +this.parseErrorMessage(error));
            this.loading = false;
        });
    }

    /* FUNCTIONS */
    handleWordLevel(event) {
        this._wordLevel = event.target.value;
        this.buildAllAnnotations();
    }

    handleGrammarFunction(event) {
        this._grammaticalFunction = event.target.value;
        this.buildAllAnnotations();
    }

    handleSentenceStructure(event) {
        this._sentenceStructure = event.target.value;
        this.buildAllAnnotations();
    }

    handleOther(event) {
        this._other = event.target.value;
        this.buildAllAnnotations();
    }

    buildAllAnnotations() {
        var allAnnotations = [];

        for (var i=0; i < this._wordLevel.length; i++) {
            let context = this;
            allAnnotations.push(context._wordLevel[i]);
        }

        for (var i=0; i < this._grammaticalFunction.length; i++) {
            let context = this;
            allAnnotations.push(context._grammaticalFunction[i]);
        }

        for (var i=0; i < this._sentenceStructure.length; i++) {
            let context = this;
            allAnnotations.push(context._sentenceStructure[i]);
        }

        for (var i=0; i < this._other.length; i++) {
            let context = this;
            allAnnotations.push(context._other[i]);
        }

        this.buildTagSet(allAnnotations);
    }

    handleChangeAnnotationCheckbox(event) {
        var fieldName = event.target.name;
        var selectedLetter = event.currentTarget.dataset.annotation;
        if(this._annotationCharacter != '' && selectedLetter != this._annotationCharacter) {
            this.clearSelectedOptions();
        }
        this._annotationCharacter = selectedLetter;
        this.annotation[fieldName] = !this.annotation[fieldName];
    }

    getSelectedCharacter() {
        var selection = window.getSelection();
        var start = selection.anchorOffset;
        var end = selection.focusOffset;

        if (start > end) {
            end = start
        }

        this.annotation.Selected_Character__c = String(selection);
        this.annotation.Selected_Character_Index__c = end;
    }

    buildTagSet(picklistValues) {
        var tagSet = '';

        for (let i=0; i < picklistValues.length; i++) {
            let context = this;

            if (tagSet == '') {
                tagSet = tagSet + context._annotationCharacter + picklistValues[i];
            } else {
                tagSet = tagSet + '; ' + context._annotationCharacter + picklistValues[i];
            }

            if (context._annotationCharacter == 'M') {
                context.annotation.Missing_M_Tagset__c = tagSet;
            }

            if (context._annotationCharacter == 'R') {
                context.annotation.Redundant_R_Tagset__c = tagSet;
            }

            if (context._annotationCharacter == 'W') {
                context.annotation.Word_Order_W_Tagset__c = tagSet;
            }

            if (context._annotationCharacter == 'S') {
                context.annotation.Incorrect_Selection_S_Tagset__c = tagSet;
            }

        }

    }

    clearSelectedOptions() {
        this.showFirstMultipicklist = !this.showFirstMultipicklist;
        this.showSecondMultipicklist = !this.showSecondMultipicklist;

        this._wordLevel = [];
        this._grammaticalFunction = [];
        this._sentenceStructure = [];
        this._other = [];

        if (this.showFirstMultipicklist) {
            this.wordLevelSecondOptions = [];
            this.grammaticalFunctionSecondOptions = [];
            this.sentenceStructureSecondOptions = [];
            this.otherValuesSecondOptions = [];

            this.wordLevelOptions = this._apexResponse.wordLevel;
            this.grammaticalFunctionOptions = this._apexResponse.grammaticalFunction;
            this.sentenceStructureOptions = this._apexResponse.sentenceStructure;
            this.otherValuesOptions = this._apexResponse.otherValues;
        } else {
            this.wordLevelOptions = [];
            this.grammaticalFunctionOptions = [];
            this.sentenceStructureOptions = [];
            this.otherValuesOptions = [];

            this.wordLevelSecondOptions = this._apexResponse.wordLevel;
            this.grammaticalFunctionSecondOptions = this._apexResponse.grammaticalFunction;
            this.sentenceStructureSecondOptions = this._apexResponse.sentenceStructure;
            this.otherValuesSecondOptions = this._apexResponse.otherValues;
        }

    }

    clearValues() {
        this.annotation = {};
        this.annotation.Missing_M__c = false;
        this.annotation.Redundant_R__c = false;
        this.annotation.Word_Order_W__c = false;
        this.annotation.Incorrect_Selection_S__c = false;
        this._annotationCharacter = '';
        this.clearSelectedOptions();
    }

    parseErrorMessage(error) {
        let errorMessage = undefined;

        if (error && error.body) {
            errorMessage = error.body.message;
        } else if (error) {
            errorMessage = error;
        }

        return errorMessage;
    }

}