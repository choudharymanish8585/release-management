import { LightningElement, api, track } from 'lwc';
import getReleaseNotes from '@salesforce/apex/SprintReleaseNotesController.getReleaseNotes';
import {showError, showNoDataError} from 'c/utils';

export default class SprintReleaseNotes extends LightningElement {
    @api sprintId;
    @api sprintDescription;
    @track response;

    @track productTags = [{label:'All', id:'all'}];
    @track bugs;
    @track features
    @track selectedProductTag = 'all';
    
    @track detailMode = false;

    connectedCallback(){
        if(this.sprintId){
            this.getReleaseNotes(this.sprintId);
        }
    }

    getReleaseNotes(sprintId){
        getReleaseNotes({
            sprintId : sprintId
        }).then(response =>{
            if(response){
                this.response = response;
                this.populateProductTags(response);
                this.filterBugsAndFeatures(response);
            } else{
                showNoDataError(this);
            }
        }).catch(error => {
            showError(error, this);
        })
    }

    populateProductTags(response){
        const productTags = [{label:'All', id:'all'}];
        if(response && response.userStories && response.userStories.length){
            response.userStories.forEach(element => {
                if(element.productTagName && element.productTagId){
                    let hasTag = false;
                    for (let index = 0; index < productTags.length; index++) {
                        const pTagId = productTags[index].id;
                        if(pTagId === element.productTagId){
                            hasTag = true;
                            break;
                        }
                    }
                    if(!hasTag){
                        productTags.push({
                            label : element.productTagName,
                            id : element.productTagId
                        });
                    }
                }
            });
        }
        this.productTags = productTags;
    }

    filterBugsAndFeatures(response, productTag){
        const bugs = [], features = [];
        if(response && response.userStories && response.userStories.length){
            response.userStories.forEach(element => {
                if(productTag && productTag !== 'all'){
                    if(element.productTagId === productTag){
                        if(element.type && element.type === 'Bug'){
                            bugs.push(element);
                        } else{
                            features.push(element);
                        }
                    }
                } else{
                    if(element.type && element.type === 'Bug'){
                        bugs.push(element);
                    } else{
                        features.push(element);
                    }
                }
            });
        }
        this.bugs = bugs;
        this.features = features;

        this.highlightSelectedProductTag();
    }

    switchDetailMode(event){
        this.detailMode = event.target.checked;
    }

    productTagClickHandler(event){
        if(event.target.dataset.id !== this.selectedProductTag){
            this.selectedProductTag = event.target.dataset.id;
            this.filterBugsAndFeatures(this.response, this.selectedProductTag);
        }
    }

    highlightSelectedProductTag(){
        const productTags = this.productTags;
        productTags.forEach(element => {
            if(element.id === this.selectedProductTag){
                element.class = 'selected product-tag'
            } else {
                element.class = 'product-tag'
            }
        });

        this.productTags = productTags;
    }

    get showBugs(){
        return this.bugs && this.bugs.length ? true : false;
    }

    get showFeatures(){
        return this.features && this.features.length ? true : false;
    }
}