import { LightningElement, track, wire } from 'lwc';
import getFilteredSprints from '@salesforce/apex/SprintListController.getFilteredSprints';
import getBaseUrl from '@salesforce/apex/ReleaseManagementUtil.getBaseUrl';
import {showError, showNoDataError} from 'c/utils';
import { NavigationMixin } from 'lightning/navigation';

export default class SprintList extends NavigationMixin(LightningElement) {

    @track sprints;

    @track openFilter = false;
    @track selectedSprintType = 'all';
    @track selectedTimespan = 'last20';

    connectedCallback(){
        //Get all sprints
        this.getSprints();
    }

    @wire(getBaseUrl) baseUrl;

    getSprints(){
        getFilteredSprints({   
            type : this.selectedSprintType, 
            timespan : this.selectedTimespan
        }).then(response => {
            if(response && response.length){
                this.sprints = this.addSprintStyle(JSON.parse(JSON.stringify(response)));
            } else{
                this.sprints = [];
                showNoDataError(this);
            }
        }).catch(error => {
            showError(error, this);
        })
    }

    addSprintStyle(sprints){
        sprints.forEach(element => {
            if(element.type && element.type.includes('Emergency')){
                element.style = 'border-bottom: 2px solid tomato;"';
            } else if(element.type && element.type.includes('Beta')){
                element.style = 'border-bottom: 2px solid blueviolet;"';
            } else{
                element.style = 'border-bottom: 2px solid yellowgreen;"';
            }
        });
        return sprints;
    }

    createSprintHandler(){
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Sprint__c',
                actionName: 'new'
            }
        });
    }

    sprintTypeChangeHandler(event){
        this.selectedSprintType = event.target.value;
    }

    timespanChangeHandler(event){
        this.selectedTimespan = event.target.value;
    }

    openFilters(){
        this.openFilter = true;
    }

    applyFilter(){
        this.openFilter = false;
        this.getSprints();
    }

    get sprintTypes() {
        return [
            { label: 'All', value: 'all' },
            { label: 'Stable', value: 'stable' },
            { label: 'Beta', value: 'beta' },
            { label: 'Emergency', value: 'emergency' },
        ];
    }

    get timespans() {
        const timespans = [
            { label: '20 Lastest Releases', value: 'last20' },
            { label: 'Upcoming', value: 'upcoming' },
            { label: 'Last 30 days', value: '1month' },
            { label: 'Last 6 months', value: '6months' },
        ];
        let currentYear = new Date().getFullYear();
        for (let index = 0; index < 5; index++) {
            const tempYear = --currentYear;
            timespans.push({ label:tempYear+'' , value: tempYear+'' });
        }
        return timespans;
    }

    get timespanLabel(){
        switch(this.selectedTimespan){
            case '1month' : return 'Last 30 days';
            case '6months' : return 'Last 6 months';
            case 'upcoming' : return 'Upcoming';
            case 'last20' : return 'Latest';
            default : return this.selectedTimespan;
        }
    }
    
}