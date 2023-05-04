const path = require('path');
const solc = require('solc');
const fs = require('fs-extra');


const buildPath = path.resolve(__dirname, 'build');
fs.removeSync(buildPath);

const campaignPath = path.resolve(__dirname, 'contracts', 'Campaign.sol');
const source = fs.readFileSync(campaignPath, 'utf-8');
const output = solc.compile(source,1).contracts;

//this ensures if there is a directory, and if there is no directory, this will create it for us
fs.ensureDirSync(buildPath);

for (let contract in output){
    fs.outputJsonSync(
        path.resolve(buildPath, contract.replace(':','') + '.json'),
        output[contract] 
    );
}