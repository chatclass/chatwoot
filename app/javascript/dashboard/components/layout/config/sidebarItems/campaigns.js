import { frontendURL } from '../../../../helper/URLHelper';

const campaigns = accountId => ({
  parentNav: 'campaigns',
  routes: ['ongoing_campaigns', 'one_off'],
  menuItems: [
    {
      icon: 'arrow-swap',
      label: 'ONGOING',
      key: 'ongoingCampaigns',
      hasSubMenu: false,
      toState: 'https://app.chatshop.ai/campaigns',      
      toStateName: 'ongoing_campaigns',
    },
    {
      key: 'oneOffCampaigns',
      icon: 'sound-source',
      label: 'ONE_OFF',
      hasSubMenu: false,
      toState: frontendURL(`accounts/${accountId}/campaigns/one_off`),
      toStateName: 'one_off',
    },
  ],
});

export default campaigns;
