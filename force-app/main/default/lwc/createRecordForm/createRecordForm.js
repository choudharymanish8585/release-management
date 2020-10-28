import { LightningElement, api } from "lwc";

export default class CreateSprintForm extends LightningElement {
  @api objectApiName;
  @api layoutType = "Full";
  @api density = "comfy";
  handleSuccess() {
    //fire success event
    const successEvt = new CustomEvent("success");
    this.dispatchEvent(successEvt);
  }

  handleCancel() {
    //fire cancel event
    const cancelEvt = new CustomEvent("cancel");
    this.dispatchEvent(cancelEvt);
  }
}
