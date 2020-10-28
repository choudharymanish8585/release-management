import { LightningElement, api, wire } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import { fireEvent } from "c/pubsub";

export default class SprintListItem extends LightningElement {
  @api sprintId;
  @api sprintNumber;
  @api title;
  @api description;
  @api releaseDate;
  @api ownerName;
  @api type;
  @api status;
  @api baseUrl;

  @wire(CurrentPageReference) pageRef;

  sprintClickHandler() {
    const sprintSelect = new CustomEvent("sprintselect", {
      detail: this.sprintId
    });
    this.dispatchEvent(sprintSelect);

    fireEvent(this.pageRef, "sprintselect", {
      sprintId: this.sprintId,
      sprintTitle: this.title
    });
  }

  get releaseIcon() {
    if (this.status) {
      switch (this.status) {
        case "On Track":
          return "utility:date_time";
        case "Completed":
          return "utility:success";
        case "Blocked":
          return "utility:error";
        default:
          return "utility:date_time";
      }
    }
    return "utility:date_time";
  }

  get iconVariant() {
    if (this.status) {
      switch (this.status) {
        case "On Track":
          return "warning";
        case "Completed":
          return "success";
        case "Blocked":
          return "error";
        default:
          return "warning";
      }
    }
    return "warning";
  }

  get releaseLabel() {
    return "Release Date: " + this.releaseDate;
  }

  get sprintUrl() {
    return this.baseUrl + "/" + this.sprintId;
  }
}
