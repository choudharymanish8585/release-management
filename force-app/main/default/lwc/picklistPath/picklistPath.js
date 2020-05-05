import { LightningElement, api, track } from "lwc";
import getPicklistValues from "@salesforce/apex/PicklistPathController.getPicklistValues";
import { showError, showNoDataError } from "c/utils";

const PATH_ITEM = "slds-path__item";
const PATH_ITEM_ACTIVE = "slds-is-current slds-is-active";
const PATH_ITEM_COMPLETE = "slds-is-complete";
const PATH_ITEM_INCOMPLETE = "slds-is-incomplete";

export default class PicklistPath extends LightningElement {
  @api sObjectName;
  @api picklistFieldName;
  @api selectedItem;

  @track picklistItems = [];

  connectedCallback() {
    if (this.sObjectName && this.picklistFieldName) {
      this.getPicklistItems(this.sObjectName, this.picklistFieldName);
    }
  }

  getPicklistItems(sObjectName, picklistFieldName) {
    getPicklistValues({
      sObjectName: sObjectName,
      picklistFieldName: picklistFieldName
    })
      .then(response => {
        if (response) {
          this.processItems(response);
        }
      })
      .catch(error => {
        showError(error, this);
      });
  }

  processItems(items) {
    if (this.selectedItem) {
      const selectedItem = this.hasSelectedItem(items);
      if (selectedItem && selectedItem.length) {
        const picklistItems = [];
        let found = false;
        items.forEach(item => {
          if (!found) {
            if (
              item.label === this.selectedItem ||
              item.value === this.selectedItem
            ) {
              found = true;
              picklistItems.push(this.markPathItemCurrent(item));
            } else {
              picklistItems.push(this.markPathItemComplete(item));
            }
          } else {
            picklistItems.push(this.markPathItemIncomplete(item));
          }
        });
        this.picklistItems = picklistItems;
      } else {
        //no value selected in picklist field
        this.picklistItems = this.markAllItemIncomplete(items);
      }
    } else {
      //selected picklist value is invalid
      this.picklistItems = this.markAllItemIncomplete(items);
    }
  }

  hasSelectedItem(items) {
    return items.filter(
      item =>
        item.label === this.selectedItem || item.value === this.selectedItem
    );
  }

  markAllItemIncomplete(items) {
    items.forEach(item => {
      this.markPathItemIncomplete(item);
    });
    return items;
  }

  markPathItemIncomplete(item) {
    item.class = `${PATH_ITEM} ${PATH_ITEM_INCOMPLETE}`;
    return item;
  }

  markPathItemCurrent(item) {
    item.class = `${PATH_ITEM} ${PATH_ITEM_ACTIVE}`;
    return item;
  }

  markPathItemComplete(item) {
    item.class = `${PATH_ITEM} ${PATH_ITEM_COMPLETE}`;
    return item;
  }

  pathClickHandler(event) {
    const clickedItem = {
      value: event.target.closest("li").dataset.value,
      label: event.target.closest("li").dataset.label
    };
    const pathClick = new CustomEvent("pathclick", { detail: clickedItem });
    this.dispatchEvent(pathClick);
  }

  pathCompleteHandler() {
    if (this.picklistItems && this.picklistItems.length) {
      const lastItem = this.picklistItems[this.picklistItems.length - 1];
      const pathComplete = new CustomEvent("pathcomplete", {
        detail: lastItem
      });
      this.dispatchEvent(pathComplete);
    }
  }

  get showPath() {
    return this.picklistItems && this.picklistItems.length ? true : false;
  }
}
