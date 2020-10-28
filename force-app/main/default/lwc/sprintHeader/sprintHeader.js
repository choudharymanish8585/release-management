import { LightningElement, api, track, wire } from "lwc";
import getSprintById from "@salesforce/apex/SprintHeaderController.getSprintById";
import { CurrentPageReference } from "lightning/navigation";
import { NavigationMixin } from "lightning/navigation";
import { deleteRecord } from "lightning/uiRecordApi";
import { showError, showNoDataError, showNotification } from "c/utils";
import { registerListener, unregisterAllListeners, fireEvent } from "c/pubsub";

export default class SprintHeader extends NavigationMixin(LightningElement) {
  @api sprintId;
  @track sprint;
  @track openReleaseNotesModal = false;

  @wire(CurrentPageReference) pageRef;

  connectedCallback() {
    if (this.sprintId) {
      this.getSprintDetails(this.sprintId);
    } else {
      registerListener("sprintselect", this.handleSprintClick, this);
      registerListener("updatesprint", this.reloadHeader, this);
    }
  }

  disconnectedCallback() {
    unregisterAllListeners(this);
  }

  getSprintDetails(sprintId) {
    getSprintById({
      sprintId: sprintId
    })
      .then(response => {
        if (response) {
          this.sprint = JSON.parse(JSON.stringify(response));
        } else {
          showNoDataError(this);
        }
      })
      .catch(error => {
        showError(error, this);
      });
  }

  handleSprintClick(event) {
    this.getSprintDetails(event.sprintId);
  }

  reloadHeader(sprintId) {
    if (this.sprint.id === sprintId) {
      this.getSprintDetails(this.sprint.id);
    }
  }

  openReleaseNotes() {
    this.openReleaseNotesModal = true;
  }

  closeModal() {
    this.openReleaseNotesModal = false;
  }

  editSprintHandler() {
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        recordId: this.sprint.id,
        objectApiName: "Sprint__c", // objectApiName is optional
        actionName: "edit"
      }
    });
  }

  deleteSprintHandler() {
    deleteRecord(this.sprint.id)
      .then(() => {
        showNotification("SUCCESS", "Sprint Deleted", "success", this);
        this.sprint = undefined;
        this.fireDeleteEvent();
      })
      .catch(error => {
        showError(error, this);
      });
  }

  fireDeleteEvent() {
    //fire sprint delete event
    fireEvent(this.pageRef, "sprintdelete", this.sprintId);
  }

  get hasSprint() {
    return this.sprint ? true : false;
  }
}
