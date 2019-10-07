import { LightningElement, api, track } from 'lwc';
import updateUserStoryStatus from '@salesforce/apex/UserStoryListItemController.updateUserStoryStatus';
import getComponentsByUserStory from '@salesforce/apex/UserStoryListItemController.getComponentsByUserStory';
import { NavigationMixin } from 'lightning/navigation';
import {showError, showNotification} from 'c/utils';

const actions = [
    { label: 'View', name: 'view' },
    { label: 'Edit', name: 'edit' }
];

const columns = [
    {label: 'API Name', fieldName: 'compLink', type: 'url', typeAttributes: { label: { fieldName: 'apiName' }, target:'_blank', tooltip: 'Click to open component' }},
    {label: 'Metadata Type', fieldName: 'metadataType', type: 'text'},
    {label: 'Change Type', fieldName: 'changeType', type: 'text'},
    { type: 'action', typeAttributes: { rowActions: actions } }
];

export default class SprintListItem extends NavigationMixin(LightningElement) {
    @api userStory;
    @api baseUrl;

    @track components;
    columns = columns;

    
    connectedCallback(){
        if(this.userStory && this.userStory.id){
            this.getUserStoryComponents(this.userStory.id);
        }
    }

    getUserStoryComponents(userStoryId){
        getComponentsByUserStory({
            userStoryId : userStoryId
        }).then(response => {
            if(response){
                this.addUrl(response);
            } else{
                this.components = [];
            }
        }).catch(error => {
            showError(error, this);
        });
    }


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

    addUrl(components){
        if(this.baseUrl){
            components.forEach(element => {
                element.compLink = this.baseUrl+'/'+element.id;
            });
            this.components = components;
        } else{
            this.components = components;
        }
    }

    handleRowAction(event){
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        const pageReference = {    
            "type": "standard__recordPage",
            "attributes": {
                recordId: row.id,
                objectApiName: 'User_Story_Component__c'
            }
        };

        switch (actionName) {
            case 'view':
                pageReference.attributes.actionName = "view"
                this[NavigationMixin.Navigate](pageReference);
            break;
            case 'edit':
                pageReference.attributes.actionName = "edit"
                this[NavigationMixin.Navigate](pageReference);
            break;
            default:break;
        }
    }

    sprintClickHandler(event){
        if(!this.showExpandOrCollapse(event.target)){
            if(this.template.querySelector('.detail-view')){
                if(this.template.querySelector('.detail-view').getAttribute('class').includes('collapsed')){
                    this.template.querySelector('.detail-view').setAttribute('class', 'detail-view slds-p-top_large expanded');
                } else{
                    this.template.querySelector('.detail-view').setAttribute('class', 'detail-view slds-p-top_large collapsed');
                }
            }
        }
    }

    pathClickHandler(event){
        this.updateStatus(this.userStory.id, event.detail.value);
    }

    pathCompleteHandler(event){
        this.updateStatus(this.userStory.id, event.detail.value);
    }

    showExpandOrCollapse(node){
        for ( ; node && node !== document; node = node.parentNode ) {
            if(node.nodeName === 'BUTTON' || node.nodeName === 'A' || node.nodeName === 'LIGHTNING-MENU-ITEM'
                || node.nodeName === 'LIGHTNING-BUTTON-MENU' || node.nodeName === 'C-PICKLIST-PATH' || node.nodeName === 'LIGHTNING-DATATABLE'){
                return true;
            }
        }
        return false;
    }

    get releaseLabel(){
        return 'Release Date: '+this.releaseDate;
    }

    get userStoryUrl(){
        return this.baseUrl+'/'+this.userStory.id;
    }

    get showComponent(){
        return this.components && this.components.length ? true : false;
    }
}