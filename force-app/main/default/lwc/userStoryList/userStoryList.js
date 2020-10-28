import { LightningElement, api, track, wire } from "lwc";
import getUserStoriesBySprint from "@salesforce/apex/UserStoryListController.getUserStoriesBySprint";
import getBaseUrl from "@salesforce/apex/SprinterUtil.getBaseUrl";
import { CurrentPageReference } from "lightning/navigation";
import { showError, showNoDataError } from "c/utils";
import { registerListener, unregisterAllListeners, fireEvent } from "c/pubsub";

export default class UserStoryList extends LightningElement {
  @api sprintId;
  @track userStories;

  @wire(CurrentPageReference) pageRef;
  @wire(getBaseUrl) baseUrl;

  isModalOpen = false;
  sprintTitle = "";

  connectedCallback() {
    if (this.sprintId) {
      this.getUserStories(this.sprintId);
    } else {
      registerListener("sprintselect", this.handleSprintClick, this);
    }
  }

  disconnectedCallback() {
    unregisterAllListeners(this);
  }

  getUserStories(sprintId) {
    // make the list blank before refreshing the list from server
    this.userStories = [];
    getUserStoriesBySprint({
      sprintId: sprintId
    })
      .then(response => {
        if (response) {
          this.userStories = response;
        } else {
          this.userStories = [];
          showNoDataError(this);
        }
      })
      .catch(error => {
        showError(error, this);
      });
  }

  createUserStoryHandler() {
    //open create user story modal
    this.isModalOpen = true;
  }

  refreshHandler() {
    //refresh list of user stories
    this.getUserStories(this.sprintId);
  }

  closeNewUserStoryModal() {
    this.isModalOpen = false;
  }

  userStorySuccessHandler() {
    // get user stories
    this.getUserStories(this.sprintId);
    fireEvent(this.pageRef, "updatesprint", this.sprintId);
    // close sprint modal
    this.isModalOpen = false;
  }

  handleSprintClick(event) {
    this.sprintId = event.sprintId;
    this.sprintTitle = event.sprintTitle;
    this.getUserStories(this.sprintId);
  }

  get hasSprint() {
    return this.sprintId ? true : false;
  }

  get cardTitle() {
    return `${this.sprintTitle} - User Stories`;
  }
}
