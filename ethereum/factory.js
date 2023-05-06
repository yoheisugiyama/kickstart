import web3 from './web3';
import CampaignFactory from './build/CampaignFactory.json';

const instance = new web3.eth.Contract(
    JSON.parse(CampaignFactory.interface),
    '0x91570176A818e932cE372e1d7f48b81D43B2e15D'
);

export default instance;