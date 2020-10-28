import { LightningElement, api, wire } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import { registerListener, unregisterAllListeners } from "c/pubsub";

export default class SprintList extends LightningElement {
  @api isInsideTab = false;

  @wire(CurrentPageReference) pageRef;

  isModalOpen = false;

  connectedCallback() {
    registerListener("sprintdelete", this.fetchSprints, this);
  }

  disconnectedCallback() {
    unregisterAllListeners(this);
  }

  createSprintHandler() {
    //open create sprint modal
    this.isModalOpen = true;
  }

  closeNewSprintModal() {
    this.isModalOpen = false;
  }

  sprintSuccessHandler() {
    this.fetchSprints();
    // close sprint modal
    this.isModalOpen = false;
  }

  fetchSprints() {
    // get sprint list component
    const sprintListComponent = this.template.querySelector(
      "c-sprint-list-main"
    );
    // reload all sprints
    sprintListComponent.getSprints();
  }
}
