/* global axios */
import ApiClient from './ApiClient';

class AccountAPI extends ApiClient {
  constructor() {
    super('', { accountScoped: true });
  }

  createAccount(data) {
    return axios.post(`${this.apiVersion}/accounts`, data);
  }

  hideTemplate(data) {
    return axios.post(`${this.apiVersion}/accounts/hideTemplate`, data);
  }

  getHideTemplate(accountId) {
    return axios.get(`${this.apiVersion}/accounts/getHideTemplate`, accountId);
  }
}

export default new AccountAPI();
