import { isAddress } from 'web3-validator';

export function assignCheckNull(value, name) {
    if (!value) {
        console.error(`${name} not provided`);
        console.error(new Error().stack);
        throw new Error(`${name} not provided`);
    }
    return value;
}

export function validateAddress(address) {
    if (!isAddress(address)) {
        console.error("Invalid address", address);
        console.error(new Error().stack);
        return false;
    }
    return true;
}

export function validateTokenId(tokenId) {
    if (tokenId > 0 && Number.isInteger(tokenId)) {
        return true;
    }
    console.error("Invalid token ID", tokenId);
    console.error(new Error().stack);
    return false;
}

export function validateSwapId(swapId) {
    if (Number.isInteger(swapId)) {
        return true;
    }
    console.error("Invalid swap ID", swapId);
    console.error(new Error().stack);
    return false;
}
