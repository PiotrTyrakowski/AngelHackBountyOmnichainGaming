import { isAddress } from 'web3-validator';

/**
 * Check if the value is null or undefined and throw an error if it is.
 * @param {*} value - The value to check.
 * @param {string} error - The error if the value is null or undefined.
 * @returns 
 */
export function assignCheckNull(value, error) {
    if (!value) {
        console.error(`${error}`);
        console.error(new Error().stack);
        throw new Error(`${error}`);
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


/**
 * Retry a function with exponential backoff
 * @async
 * @param {Function} fn - The function to retry (async).
 * @param {number} retries - The maximum number of retries.
 * @param {number} baseDelayMs - The base delay in milliseconds. (default is 1000ms)
 * @returns Plain unmodified return value of the function or throws an error if the max retries are reached.
 */
export async function exponentialBackoffRetry(fn, retries = 1, baseDelayMs = 1000) {
    let delay = baseDelayMs + Math.random() * baseDelayMs;
    try {
        for (let i = 0; i < retries; i++) {
            try {
                return await fn();
            } catch (error) {
                console.log(`With function ${fn.name}:`, error);
                console.log(`Retrying in ${delay}ms...`);
                await new Promise(resolve => setTimeout(resolve, delay));
                delay *= 2;
            }
        }
    } catch (error) {
        console.error(`Error after ${retries} retries:`, error);
        throw error;
    }
}
