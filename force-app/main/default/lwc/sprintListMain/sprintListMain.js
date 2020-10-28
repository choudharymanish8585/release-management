import { LightningElement, track, wire, api } from "lwc";
import getFilteredSprints from "@salesforce/apex/SprintListController.getFilteredSprints";
import getBaseUrl from "@salesforce/apex/SprinterUtil.getBaseUrl";
import { showError, showNoDataError } from "c/utils";

export default class SprintListMain extends LightningElement {
  @track sprints = [];

  @track openFilter = false;
  @track selectedSprintType = "all";
  @track selectedTimespan = "last20";

  @api listClass;

  connectedCallback() {
    //Get all sprints
    this.getSprints();
  }

  @wire(getBaseUrl) baseUrl;

  @api
  getSprints() {
    getFilteredSprints({
      type: this.selectedSprintType,
      timespan: this.selectedTimespan
    })
      .then(response => {
        if (response && response.length) {
          this.sprints = this.addSprintClass(
            JSON.parse(JSON.stringify(response))
          );
        } else {
          this.sprints = [];
          showNoDataError(this);
        }
      })
      .catch(error => {
        showError(error, this);
      });
  }

  addSprintClass(sprints) {
    sprints.forEach(element => {
      if (element.type && element.type.includes("Emergency")) {
        element.class = "slds-item sprint-item emergency-sprint";
      } else if (element.type && element.type.includes("Beta")) {
        element.class = "slds-item sprint-item beta-sprint";
      } else {
        element.class = "slds-item sprint-item prod-sprint";
      }
    });
    return sprints;
  }

  sprintTypeChangeHandler(event) {
    this.selectedSprintType = event.target.value;
  }

  timespanChangeHandler(event) {
    this.selectedTimespan = event.target.value;
  }

  openFilters() {
    this.openFilter = true;
  }

  applyFilter() {
    this.openFilter = false;
    this.getSprints();
  }

  get sprintTypes() {
    return [
      { label: "All", value: "all" },
      { label: "Stable", value: "stable" },
      { label: "Beta", value: "beta" },
      { label: "Emergency", value: "emergency" }
    ];
  }

  get timespans() {
    const timespans = [
      { label: "20 Lastest Releases", value: "last20" },
      { label: "Upcoming", value: "upcoming" },
      { label: "Last 30 days", value: "onemonth" },
      { label: "Last 6 months", value: "sixmonths" }
    ];
    let currentYear = new Date().getFullYear();
    for (let index = 0; index < 5; index++) {
      const tempYear = --currentYear;
      timespans.push({ label: tempYear + "", value: tempYear + "" });
    }
    return timespans;
  }

  get timespanLabel() {
    switch (this.selectedTimespan) {
      case "onemonth":
        return "Last 30 days";
      case "sixmonths":
        return "Last 6 months";
      case "upcoming":
        return "Upcoming";
      case "last20":
        return "Latest";
      default:
        return this.selectedTimespan;
    }
  }

  get sprintItemClass() {
    return this.listClass
      ? `slds-p-around_small ${this.listClass}`
      : "slds-p-around_small";
  }
}
