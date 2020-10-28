import { LightningElement, api, track } from "lwc";

export default class OverlayModal extends LightningElement {
  @api modalTitle;
  @api hideSuccessButton = false;
  @api hideCancelButton = false;
  @api successActionName = "OK";
  @api cancelActionName = "Cancel";

  closeModal() {
    //fire close event
    const closeModalEvt = new CustomEvent("close");
    this.dispatchEvent(closeModalEvt);
  }

  successActionHandler() {
    //fire success button handler
    const successEvt = new CustomEvent("success");
    this.dispatchEvent(successEvt);
  }
}
