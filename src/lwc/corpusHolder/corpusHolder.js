/**
    Author:         MGrajcar
    Company:        UCB 4C
    History:        mgrajcar 3/25/2022 - Created.
 */

import { LightningElement, track } from 'lwc';

export default class CorpusHolder extends LightningElement {

    /* VARIABLES */

    //handlers
    @track showButtons = true;
    @track newCorpus = false;
    @track newAnnotations = false;

    /* HANDLERS */
    openCorpus() {
        this.newCorpus = true;
        this.showButtons = false;
    }

    openAnnotations() {
        this.newAnnotations = true;
        this.showButtons = false;
    }

}