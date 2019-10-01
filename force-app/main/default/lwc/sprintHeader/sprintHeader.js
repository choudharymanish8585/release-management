import { LightningElement, api, track, wire } from 'lwc';
import getSprintById from '@salesforce/apex/SprintHeaderController.getSprintById';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import {showError, showNoDataError} from 'c/utils';
import { registerListener, unregisterAllListeners } from 'c/pubsub';

export default class SprintHeader extends NavigationMixin(LightningElement) {
    @api sprintId;
    @track sprint;
    @track openReleaseNotesModal = false;

    @wire(CurrentPageReference) pageRef;

    connectedCallback(){
        if(this.sprintId){
            this.getSprintDetails(this.sprintId);
        } else{
            registerListener('sprintselect', this.handleSprintClick, this);
        }
    }

    disconnectedCallback(){
        unregisterAllListeners(this);
    }

    getSprintDetails(sprintId){
        getSprintById({
            sprintId : sprintId
        }).then(response =>{
            if(response){
                this.sprint = JSON.parse(JSON.stringify(response));
            } else{
                showNoDataError(this);
            }
        }).catch(error => {
            showError(error, this);
        })
    }

    handleSprintClick(sprintId){
        this.getSprintDetails(sprintId);
    }

    openReleaseNotes() {
        this.openReleaseNotesModal = true
    }

    closeModal() {
        this.openReleaseNotesModal = false
    }

    editSprintHandler(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.sprint.id,
                objectApiName: 'Sprint__c', // objectApiName is optional
                actionName: 'edit'
            }
        });
    }

    get hasSprint(){
        return this.sprint ? true : false;
    }
}