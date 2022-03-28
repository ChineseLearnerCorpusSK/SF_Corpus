import { LightningElement, track } from 'lwc';
import getCorpusInformation from '@salesforce/apex/CorpusEndpoint.getCorpusInformation';
import insertCorpusInformation from '@salesforce/apex/CorpusEndpoint.insertCorpusInformation';

export default class CorpusCreation extends LightningElement {

    /* VARIABLES */

    //record
    @track corpus;

    //picklists
    @track genderOptions = [];
    @track degreeOptions = [];
    @track studyExchangeOptions = [];
    @track proficiencyOptions = [];
    @track hskOptions = [];
    @track bilingualOptions = [];
    @track chineseHeritageOptions = [];
    @track translationOptions = [];

    //handlers
    @track openAnnotations = false;
    @track textLength = '';
    @track loading = true;

    /* INIT */
    connectedCallback() {
        this.fetchData();
    }

    /* ENDPOINTS */
    fetchData() {
        this.loading = true;
        getCorpusInformation({}).then(result => {
            this.corpus = result.corpus;
            this.genderOptions = result.gender;
            this.degreeOptions = result.degree;
            this.studyExchangeOptions = result.studyExchange;
            this.proficiencyOptions = result.proficiency;
            this.hskOptions = result.hsk;
            this.bilingualOptions = result.bilingual;
            this.chineseHeritageOptions = result.chineseHeritage;
            this.translationOptions = result.translation;

            this.loading = false;
        }).catch(error => {
            console.log('Error fetch data: ' +this.parseErrorMessage(error));
            this.loading = false;
        });
    }

    saveCorpus() {
        this.loading = true;
        insertCorpusInformation({corpusForSave : this.corpus}).then(result => {
            this.corpus = result;
            this.openAnnotations = true;
            this.fetchTagSet();
        }).catch(error => {
            console.log('Error save corpus: ' +this.parseErrorMessage(error));
            this.loading = false;
        });
    }

    /* FUNCTIONS */
    handleChange(event) {
        var fieldName = event.target.name;
        this.corpus[fieldName] = event.target.value;

        if (fieldName == 'Corpus_Text__c') {
            this.corpus.Text_Length__c = this.corpus.Corpus_Text__c.length;
        }

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