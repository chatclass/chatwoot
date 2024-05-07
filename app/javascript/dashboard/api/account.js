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
}

export default new AccountAPI();
