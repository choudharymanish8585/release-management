import { LightningElement, api } from 'lwc';
import updateUserStoryStatus from '@salesforce/apex/UserStoryListController.updateUserStoryStatus';
import { NavigationMixin } from 'lightning/navigation';
import {showError, showNotification} from 'c/utils';

export default class SprintListItem extends NavigationMixin(LightningElement) {
    @api userStory;
    @api baseUrl;


    handleOnselect(event) {
        switch(event.detail.value){
            case "edit" : 
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.userStory.id,
                    objectApiName: 'User_Story__c', // objectApiName is optional
                    actionName: 'edit'
                }
            }); break;
            case "add" : 
            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'User_Story_Component__c',
                    actionName: 'new'
                }
            }); break;
            default: break;
        }
    }

    updateStatus(id, status){
        updateUserStoryStatus({
            status : status,
            userStoryId : id
        }).then(response => {
            if(response && response === 'success'){
                showNotification('SUCCESS', 'Status updated!!', 'success', this);
            } else{
                showNotification('ERROR', response, 'error', this);
            }
        }).catch(error => {
            showError(error, this);
        })
    }

    pathClickHandler(event){
        this.updateStatus(this.userStory.id, event.detail.value);
    }

    pathCompleteHandler(event){
        this.updateStatus(this.userStory.id, event.detail.value);
    }

    get releaseLabel(){
        return 'Release Date: '+this.releaseDate;
    }

    get userStoryUrl(){
        return this.baseUrl+'/'+this.userStory.id;
    }
}