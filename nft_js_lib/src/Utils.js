import { isAddress } from 'web3-validator';

/**
 * Check if the value is null or undefined and throw an error if it is.
 * @param {*} value - The value to check.
 * @param {string} name - The name of the value. 
 * @returns 
 */
export function assignCheckNull(value, name) {
    if (!value) {
        console.error(`${name} not provided`);
        console.error(new Error().stack);
        throw new Error(`${name} not provided`);
    }
    return value;
}

/**
 * Check if the address is a valid web3 address.
 * @param {*} address 
 * @returns 
 */
export function validateAddress(address) {
    if (!isAddress(address)) {
        console.error("Invalid address", address);
        console.error(new Error().stack);
        return false;
    }
    return true;
}

/**
 * Check if the token ID is a valid integer.
 * @param {*} tokenId 
 * @returns 
 */
export function validateTokenId(tokenId) {
    if (tokenId >= 0 && Number.isInteger(tokenId)) {
        return true;
    }
    console.error("Invalid token ID", tokenId);
    console.error(new Error().stack);
    return false;
}

/**
 * Check if the swap ID is a valid integer.
 * @param {*} swapId 
 * @returns 
 */
export function validateSwapId(swapId) {
    if (Number.isInteger(swapId)) {
        return true;
    }
    console.error("Invalid swap ID", swapId);
    console.error(new Error().stack);
    return false;
}


export function zeroAddress() {
    return "0x0000000000000000000000000000000000000000";
}