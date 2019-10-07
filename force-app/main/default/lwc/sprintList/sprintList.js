import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class SprintList extends NavigationMixin(LightningElement) {
    @api isInsideTab = false;

    createSprintHandler(){
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Sprint__c',
                actionName: 'new'
            }
        });
    }
    
}