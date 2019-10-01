import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//show toast notification with provide title and message
const showNotification = (title, message, variant, ref) => {
    const evt = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
    });
    ref.dispatchEvent(evt);
}

//show toast notification with provide title and message
const showNoDataError = (ref) => {
    showNotification('ERROR', 'No data retrieved from server. Please check exception logs!!', 'error', ref);
}

const showNullMessage = (message) =>{
    return message && message.includes('newValue cannot be undefined') ? true : false;
}

/**
 * Show error returned from server
 * @param {error} error 
 */
const showError = (error, ref) => {
    if(error.message){
        if(showNullMessage(error.message)){
            showNoDataError(ref);
        } else{
            showNotification('ERROR IN FETCHING DATA', error.message, 'error', ref);
        }
    } else if(error.body && error.body.message){
        if(showNullMessage(error.body.message)){
            showNoDataError(ref);
        } else{
            showNotification('ERROR IN FETCHING DATA', error.body.message, 'error', ref);
        }
    } else {
        if(showNullMessage(error)){
            showNoDataError(ref);
        } else{
            showNotification('ERROR IN FETCHING DATA', error.body.message, 'error', ref);
        }
    }
};

export {showError, showNotification, showNoDataError}

