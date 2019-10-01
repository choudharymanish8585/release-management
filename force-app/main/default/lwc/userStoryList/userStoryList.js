import { LightningElement, api, track, wire } from 'lwc';
import getUserStoriesBySprint from '@salesforce/apex/UserStoryListController.getUserStoriesBySprint';
import getBaseUrl from '@salesforce/apex/ReleaseManagementUtil.getBaseUrl';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import {showError, showNoDataError} from 'c/utils';
import { registerListener, unregisterAllListeners } from 'c/pubsub';

export default class UserStoryList extends NavigationMixin(LightningElement) {
    @api sprintId;
    @track userStories;
    @track privateSprintId;

    @wire(CurrentPageReference) pageRef;
    @wire(getBaseUrl) baseUrl;

    connectedCallback(){
        if(this.sprintId){
            this.privateSprintId = this.sprintId;
            this.getUserStories(this.sprintId);
        } else{
            registerListener('sprintselect', this.handleSprintClick, this);
        }
    }

    disconnectedCallback(){
        unregisterAllListeners(this);
    }

    getUserStories(sprintId){
        getUserStoriesBySprint({
            sprintId : sprintId
        }).then(response => {
            if(response){
                this.userStories = response;
            } else{
                this.userStories = []
                showNoDataError(this);
            }
        }).catch(error =>{
            showError(error, this);
        });
    }

    createUserStoryHandler(){
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'User_Story__c',
                actionName: 'new'
            }
        });
    }

    handleSprintClick(sprintId){
        this.privateSprintId = sprintId;
        this.getUserStories(sprintId);
    }

    get hasSprint(){
        return this.privateSprintId ? true : false;
    }
}