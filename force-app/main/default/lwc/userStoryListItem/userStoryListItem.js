import { LightningElement, api, track, wire } from "lwc";
import updateUserStoryStatus from "@salesforce/apex/UserStoryListItemController.updateUserStoryStatus";
import getComponentsByUserStory from "@salesforce/apex/UserStoryListItemController.getComponentsByUserStory";
import getUserStoryById from "@salesforce/apex/UserStoryListItemController.getUserStoryById";
import { NavigationMixin } from "lightning/navigation";
import { deleteRecord } from "lightning/uiRecordApi";
import { CurrentPageReference } from "lightning/navigation";
import { fireEvent } from "c/pubsub";
import { showError, showNotification } from "c/utils";

const actions = [
  { label: "View", name: "view" },
  { label: "Edit", name: "edit" },
  { label: "Delete", name: "delete" }
];

const columns = [
  {
    label: "API Name",
    fieldName: "compLink",
    type: "url",
    typeAttributes: {
      label: { fieldName: "apiName" },
      target: "_blank",
      tooltip: "Click to open component"
    }
  },
  { label: "Metadata Type", fieldName: "metadataType", type: "text" },
  { label: "Change Type", fieldName: "changeType", type: "text" },
  { type: "action", typeAttributes: { rowActions: actions } }
];

export default class UserStoryListItem extends NavigationMixin(
  LightningElement
) {
  @api userStory;
  @api baseUrl;

  @track components;
  columns = columns;

  isModalOpen = false;

  @wire(CurrentPageReference) pageRef;

  connectedCallback() {
    if (this.userStory && this.userStory.id) {
      this.getUserStoryComponents(this.userStory.id);
    }
  }

  getUserStoryComponents(userStoryId) {
    getComponentsByUserStory({
      userStoryId: userStoryId
    })
      .then(response => {
        if (response) {
          this.addUrl(response);
        } else {
          this.components = [];
        }
      })
      .catch(error => {
        showError(error, this);
      });
  }

  getUserStory(userStoryId) {
    getUserStoryById({
      userStoryId: userStoryId
    })
      .then(response => {
        this.userStory = response;
      })
      .catch(error => {
        showError(error, this);
      });
  }

  handleOnselect(event) {
    switch (event.detail.value) {
      case "edit":
        this[NavigationMixin.Navigate]({
          type: "standard__recordPage",
          attributes: {
            recordId: this.userStory.id,
            objectApiName: "User_Story__c", // objectApiName is optional
            actionName: "edit"
          }
        });
        break;
      case "add":
        this.isModalOpen = true;
        break;
      case "delete":
        this.deleteUserStory();
      default:
        break;
    }
  }

  updateStatus(id, status) {
    updateUserStoryStatus({
      status: status,
      userStoryId: id
    })
      .then(response => {
        if (response && response === "success") {
          showNotification("SUCCESS", "Status updated!!", "success", this);
          this.fireUpdateEvent();
        } else {
          showNotification("ERROR", response, "error", this);
        }
      })
      .catch(error => {
        showError(error, this);
      });
  }

  deleteUserStory() {
    deleteRecord(this.userStory.id)
      .then(() => {
        showNotification("SUCCESS", "User Story Deleted", "success", this);
        this.fireDeleteEvent();
      })
      .catch(error => {
        showError(error, this);
      });
  }

  addUrl(components) {
    if (this.baseUrl) {
      components.forEach(element => {
        element.compLink = this.baseUrl + "/" + element.id;
      });
      this.components = components;
    } else {
      this.components = components;
    }
  }

  handleRowAction(event) {
    const actionName = event.detail.action.name;
    const row = event.detail.row;

    const pageReference = {
      type: "standard__recordPage",
      attributes: {
        recordId: row.id,
        objectApiName: "User_Story_Component__c"
      }
    };

    switch (actionName) {
      case "view":
        pageReference.attributes.actionName = "view";
        this[NavigationMixin.Navigate](pageReference);
        break;
      case "edit":
        pageReference.attributes.actionName = "edit";
        this[NavigationMixin.Navigate](pageReference);
        break;
      case "delete":
        deleteRecord(row.id)
          .then(() => {
            showNotification(
              "SUCCESS",
              "User Story Component Deleted",
              "success",
              this
            );
            this.reloadItem();
          })
          .catch(error => {
            showError(error, this);
          });
        break;
      default:
        break;
    }
  }

  fireDeleteEvent() {
    //fire delete event
    const deleteEvt = new CustomEvent("delete");
    this.dispatchEvent(deleteEvt);
    fireEvent(this.pageRef, "updatesprint", this.userStory.sprintId);
  }

  fireUpdateEvent() {
    //fire update event
    const updatevt = new CustomEvent("update");
    this.dispatchEvent(updatevt);
  }

  sprintClickHandler(event) {
    if (!this.showExpandOrCollapse(event.target)) {
      if (this.template.querySelector(".detail-view")) {
        if (
          this.template
            .querySelector(".detail-view")
            .getAttribute("class")
            .includes("collapsed")
        ) {
          this.template
            .querySelector(".detail-view")
            .setAttribute("class", "detail-view slds-p-top_large expanded");
        } else {
          this.template
            .querySelector(".detail-view")
            .setAttribute("class", "detail-view slds-p-top_large collapsed");
        }
      }
    }
  }

  pathClickHandler(event) {
    this.updateStatus(this.userStory.id, event.detail.value);
  }

  pathCompleteHandler(event) {
    this.updateStatus(this.userStory.id, event.detail.value);
  }

  showExpandOrCollapse(node) {
    for (; node && node !== document; node = node.parentNode) {
      if (
        node.nodeName === "BUTTON" ||
        node.nodeName === "A" ||
        node.nodeName === "LIGHTNING-MENU-ITEM" ||
        node.nodeName === "LIGHTNING-BUTTON-MENU" ||
        node.nodeName === "C-PICKLIST-PATH" ||
        node.nodeName === "LIGHTNING-DATATABLE"
      ) {
        return true;
      }
    }
    return false;
  }

  closeUserStoryComponentModal() {
    this.isModalOpen = false;
  }

  uscSuccessHandler() {
    this.isModalOpen = false;
    this.reloadItem();
  }

  reloadItem() {
    this.getUserStoryComponents(this.userStory.id);
    this.getUserStory(this.userStory.id);
  }

  get releaseLabel() {
    return "Release Date: " + this.releaseDate;
  }

  get userStoryUrl() {
    return this.baseUrl + "/" + this.userStory.id;
  }

  get showComponent() {
    return this.components && this.components.length ? true : false;
  }
}
